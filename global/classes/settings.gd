class_name Settings
extends Reference


var sounds: bool = true
var music: bool = true setget update_music


func update_music(value: bool) -> void:
	Music.set_player_status(value)
	music = value
