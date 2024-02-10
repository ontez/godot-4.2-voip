extends Node

const BUFFER_SIZE : int = 512
const RECORD_BUS_NAME : String = "Record"
const MINIMUM_RECORDING_VOLUME : float = 0.0

var SHOULD_PLAYBACK_VOICE : bool = false

var recorder : AudioStreamPlayer

## >> the StreamPlayers associated with each person voice
var peer_players : Dictionary # { "id" : AudioStreamPlayer }

var compressor : VoiceCompressor = VoiceCompressor.new()
var encoder : Opus = Opus.new()
var decoder : Opus = Opus.new()

var effect : AudioEffectCapture = null

var audio_thread = Thread.new()

func _ready():
	_setup()
	
func _process(delta):
	if(Client.lobby != ""):
		if effect.can_get_buffer(BUFFER_SIZE):
			play_data.rpc(Client.id, effect.get_buffer(BUFFER_SIZE))
		else:
			OS.delay_msec(10)

func _setup():
	var mute_bus = _create_bus()
	AudioServer.set_bus_mute(mute_bus, !SHOULD_PLAYBACK_VOICE)
	
	var record_bus = _create_bus()
	effect = AudioEffectCapture.new()
	AudioServer.add_bus_effect(record_bus, effect)
	AudioServer.set_bus_send(record_bus, AudioServer.get_bus_name(mute_bus))
	
	recorder = AudioStreamPlayer.new()
	recorder.name = "Voice Recorder"
	recorder.stream = AudioStreamMicrophone.new()
	recorder.bus = AudioServer.get_bus_name(record_bus)
	recorder.autoplay
	
	add_child(recorder)
	recorder.play()
	
func _create_bus() -> int:
	var index = AudioServer.bus_count
	AudioServer.add_bus()
	return index
	
@rpc("any_peer", "call_remote", "reliable")
func play_data(sender_id : int, data: PackedVector2Array) -> void:
	if(peer_players.is_empty()):
		push_warning("[VOICE CHAT] No peer owner AudioStreamPlayers defined: " + str(peer_players))
		return
	if(peer_players.has(sender_id) == false):
		var peers = Client.lobby_members
		push_warning("[VOICE CHAT] Sender of voice has no associated player: %s" + str(sender_id))
		
		return

	for i in range(data.size()):
		peer_players[multiplayer.get_remote_sender_id()].get_stream_playback().push_frame(data[0])
		data.remove_at(0)

## >> -- Methods -- << ##

func add_peer_voice(_id : int, player : AudioStreamPlayer):
	peer_players.merge({_id : player})

func erase_peer_voice(_id : int):
	if(peer_players.has(_id)):
		peer_players.erase(_id)

## >> -- Helpers -- << ##

func _get_recording_data() -> PackedFloat32Array:
	var data = effect.get_buffer(BUFFER_SIZE)
	return encoder.encode(data)
	
func _get_recording_volume() -> float:
	var stereo_data = effect.get_buffer(effect.get_frames_available())
	
	var max_registered_amplitude : float = 0.0
	
	for i in range(stereo_data.size()):
		var average_stereo_data = (stereo_data[i].x + stereo_data[i].y) / 2
		max_registered_amplitude = max(average_stereo_data, max_registered_amplitude)

	return max_registered_amplitude
