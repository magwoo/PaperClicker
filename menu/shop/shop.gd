class_name Shop
extends VBoxContainer


export var menu_width: float = 360.0

var opened: bool = false
var tween: Tween = Tween.new()

onready var viewport: Viewport = self.get_viewport()


func _ready() -> void:
	self.rect_min_size.x = 0.0
	self.modulate.a = 0.0
	self.add_child(tween)


func _process(delta: float) -> void:
	if _is_mouse_open() && !opened: open()
	if !_is_mouse_open() && opened: close()


func _input(event: InputEvent) -> void:
	if event is InputEventPanGesture: print(event.delta)


func open() -> void:
	opened = true
	tween.interpolate_property(
		self, 'modulate', self.modulate, Color.white, 0.15
	)
	tween.interpolate_property(
		self, 'rect_min_size', self.rect_min_size, Vector2(menu_width, 0.0),
		0.2, Tween.TRANS_BACK, Tween.EASE_OUT
	); tween.start()


func close() -> void:
	opened = false
	tween.interpolate_property(
		self, 'modulate', self.modulate, Color.transparent, 0.1
	)
	tween.interpolate_property(
		self, 'rect_min_size', self.rect_min_size, Vector2(0.0, 0.0), 0.2,
		Tween.TRANS_BACK, Tween.EASE_OUT
	); tween.start()


func _is_mouse_open() -> bool:
	return get_global_mouse_position().x > viewport.size.x - menu_width / 1.5
