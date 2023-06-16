extends Node


const music: AudioStream = preload('res://global/music/music.mp3')

onready var player: AudioStreamPlayer = $AudioStreamPlayer


func _ready() -> void:
	player.stream = music
	player.play()
