extends Node


const music: AudioStream = preload('res://global/music/music.mp3')

var tween: Tween = Tween.new()

onready var player: AudioStreamPlayer = $AudioStreamPlayer


func _ready() -> void:
	player.stream = music
	self.add_child(tween)


func play() -> void:
	tween.interpolate_method(self, 'set_volume', -30.0, -10.0, 2.0)
	tween.start()
	player.play()


func set_volume(value: float) -> void:
	AudioServer.set_bus_volume_db(1, value)


func set_player_status(status: bool) -> void:
	player.stream_paused = status


func pause() -> void:
	player.stream_paused = true


func resume() -> void:
	player.stream_paused = false
