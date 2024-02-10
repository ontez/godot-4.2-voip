
# Godot 4.2.1 RPC-VOIP

A quick and probably dirty implementation of VOIP via Godot's built in networking solution and its RPCs. 




## Acknowledgements

 - [Netfox Voip Example](https://github.com/foxssake/netfox-voip-example)
 - [Finepoint CGI - Basics of Godot VOIP](https://www.youtube.com/watch?v=AomgXrpiRmM)

## ⚠️Note ⚠️

NOTE: To utilize this project, you must have already implemented your own form of multiplayer in Godot, utilizing its built-in multiplayer peer system and client connection. Additionally, 'lobby-voice-handler.gd' is an example of how to implement the voice chat, but it's peer_connected signals will not work on their own: you must implement this into your own project with however you handle peer connection and disconnection.




## Usage

1. Download scripts to any directory within your Godot project. 

2. Make 'voice-chat.gd' an Autoload named VoiceChat.

3. Ensure audio input is enabled in the Project Settings. 

4. Take a look at 'lobby-voice-handler.gd' as a guide to how to implement it. (voice-chat.gd requires AudioStreamPlayers to push the audio to, and each player must be connected to a multiplayer peer's id)

You're done!
## Compatibility

Godot 4.2.1 ✅ **Version the project was created; tested and works.**

Godot 4.1 ⚠️ **Untested: Might work**

Godot 4.0 ⚠️ **Untested: Might work**

Godot 3 ❌ **Will not work as Godot 4 networking functionality is a pre-requisite. Could possibly be back-ported using Godot 3 networking, though.**