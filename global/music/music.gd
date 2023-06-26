extends Node


const music: AudioStream = preload('res://global/music/music.mp3')

onready var player: AudioStreamPlayer = $AudioStreamPlayer


func _ready() -> void:
	player.stream = music
	player.play()


func set_player_status(status: bool) -> void:
	player.stream_paused = status


func pause() -> void:
	player.stream_paused = true


func resume() -> void:
	player.stream_paused = false
