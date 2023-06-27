class_name Settings
extends Reference


var sounds: bool = true setget update_sounds
var music: bool = true setget update_music


func update_music(value: bool) -> void:
	Music.set_player_status(value)
	music = value


func update_sounds(value: bool) -> void:
	AudioServer.set_bus_mute(2, value)
	sounds = value
