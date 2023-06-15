class_name Shop
extends Panel


var opened: bool = false
var tween: Tween = Tween.new()

onready var viewport: Viewport = self.get_viewport()


func _ready() -> void:
	self.add_child(tween)


func _process(delta: float) -> void:
	if get_global_mouse_position().x > viewport.size.x - 420 && !opened:
		opened = true
		open()
	if get_global_mouse_position().x < viewport.size.x - 420 && opened:
		opened = false
		close()


func open() -> void:
	tween.interpolate_property(
		self, 'rect_min_size', self.rect_min_size, Vector2(360.0, 0.0), 0.2,
		Tween.TRANS_BACK, Tween.EASE_OUT
	); tween.start()


func close() -> void:
	tween.interpolate_property(
		self, 'rect_min_size', self.rect_min_size, Vector2(0.0, 0.0), 0.2,
		Tween.TRANS_BACK, Tween.EASE_OUT
	); tween.start()
