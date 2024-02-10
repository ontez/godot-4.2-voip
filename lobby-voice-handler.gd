extends Node

func _ready():
	multiplayer.multiplayer_peer.peer_connected.connect(_on_peer_joined)
	multiplayer.multiplayer_peer.peer_disconnected.connect(_on_peer_left)
	
func _on_peer_joined(id : int):
	var player = AudioStreamPlayer.new()
	player.stream = AudioStreamGenerator.new()
	player.autoplay = true
	
	add_child(player)
	
	VoiceChat.peer_players[id] = player

func _on_peer_left(id : int):
	VoiceChat.peer_players[id].queue_free()
	VoiceChat.peer_players.erase(id)
