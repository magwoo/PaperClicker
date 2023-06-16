class_name Shop
extends Panel


export var menu_width: float = 360.0

var opened: bool = false
var tween: Tween = Tween.new()

onready var viewport: Viewport = self.get_viewport()


func _ready() -> void:
	self.add_child(tween)


func _process(delta: float) -> void:
	if _is_mouse_open() && !opened:
		opened = true
		open()
	if !_is_mouse_open() && opened:
		opened = false
		close()


func open() -> void:
	tween.interpolate_property(
		self, 'rect_min_size', self.rect_min_size, Vector2(menu_width, 0.0),
		0.2, Tween.TRANS_BACK, Tween.EASE_OUT
	); tween.start()


func close() -> void:
	tween.interpolate_property(
		self, 'rect_min_size', self.rect_min_size, Vector2(0.0, 0.0), 0.2,
		Tween.TRANS_BACK, Tween.EASE_OUT
	); tween.start()


func _is_mouse_open() -> bool:
	return get_global_mouse_position().x > viewport.size.x - menu_width / 1.5
