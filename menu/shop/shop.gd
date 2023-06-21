class_name Shop
extends Control


export var menu_width: float = 256.0

var opened: bool = false
var tween: Tween = Tween.new()

onready var button_container: VBoxContainer = $MarginContainer/VBoxContainer
onready var margin_container: MarginContainer = $MarginContainer
onready var open_player: AudioStreamPlayer = $OpenPlayer
onready var close_player: AudioStreamPlayer = $ClosePlayer
onready var viewport: Viewport = self.get_viewport()


func _ready() -> void:
	self.rect_min_size.x = 0.0
	self.modulate.a = 0.0
	self.add_child(tween)
	close()


func _process(delta: float) -> void:
	if _is_mouse_open(menu_width / 2.0) && !opened: open()
	if !_is_mouse_open(menu_width * 1.5) && opened: close()


func _input(event: InputEvent) -> void:
	if !event is InputEventPanGesture || !opened: return
	self.margin_top -= event.delta.y * 25.0
	var bottom_line: float = -button_container.rect_size.y + viewport.size.y / 1.5
	self.margin_top = clamp(self.margin_top, bottom_line, 0.0)


func open() -> void:
	opened = true
	open_player.play()
	tween.interpolate_property(
		self, 'modulate', self.modulate, Color.white, 0.15
	); tween.interpolate_property(
		margin_container, 'rect_position', margin_container.rect_position,
		Vector2(0.0, 0.0), 0.2
	);  tween.interpolate_property(
		self, 'rect_min_size', self.rect_min_size, Vector2(menu_width, 0.0),
		0.2, Tween.TRANS_BACK, Tween.EASE_OUT
	); tween.start()


func close() -> void:
	opened = false
	close_player.play()
	tween.interpolate_property(
		self, 'modulate', self.modulate, Color.transparent, 0.1
	); tween.interpolate_property(
		margin_container, 'rect_position', margin_container.rect_position,
		Vector2(0.0, 0.0), 0.2
	);  tween.interpolate_property(
		self, 'rect_min_size', self.rect_min_size, Vector2(0.0, 0.0),
		0.2, Tween.TRANS_BACK, Tween.EASE_OUT
	); tween.start()


func _is_mouse_open(value: float) -> bool:
	return get_global_mouse_position().x > viewport.size.x - value
