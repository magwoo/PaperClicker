class_name SettingsMenu
extends Control


var is_opened: bool = false

onready var margin_container: MarginContainer = $MarginContainer
onready var close_player: AudioStreamPlayer = $ClosePlayer
onready var open_player: AudioStreamPlayer = $OpenPlayer
onready var tween: Tween = Tween.new()


func _ready() -> void:
	self.add_child(tween)
	close()


func _process(delta: float) -> void:
	if get_global_mouse_position().x > 420.0 && is_opened: close()
	if get_global_mouse_position().y > 420.0: return
	if get_global_mouse_position().x < 128.0 && !is_opened: open()


func open() -> void:
	is_opened = true
	self.show()
	open_player.play()
	tween.interpolate_property(
		self, 'rect_min_size', self.rect_min_size, Vector2(256.0, 0.0),
		0.2, Tween.TRANS_BACK, Tween.EASE_OUT
	); tween.interpolate_property(
		self, 'modulate', self.modulate, Color.white, 0.1
	); tween.interpolate_property(
		margin_container, 'rect_position', margin_container.rect_position,
		Vector2.ZERO, 0.2, Tween.TRANS_BACK, Tween.EASE_OUT
	); tween.start()


func close() -> void:
	is_opened = false
	close_player.play()
	tween.interpolate_property(
		self, 'rect_min_size', self.rect_min_size, Vector2.ZERO,
		0.2, Tween.TRANS_BACK, Tween.EASE_OUT
	); tween.interpolate_property(
		self, 'modulate', self.modulate, Color.transparent, 0.1
	); tween.interpolate_property(
		margin_container, 'rect_position', margin_container.rect_position,
		Vector2(-128.0, 0.0), 0.2, Tween.TRANS_BACK, Tween.EASE_OUT
	);  tween.start()
