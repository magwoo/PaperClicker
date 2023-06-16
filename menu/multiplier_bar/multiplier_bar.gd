class_name MultiplierBar
extends ProgressBar


export(Curve) var animation_curve: Curve

var tween: Tween = Tween.new()

onready var label: Label = $MultiplierLabel
onready var viewport: Viewport = self.get_viewport()


func _ready() -> void:
	self.add_child(tween)
	label.rect_pivot_offset = label.rect_size / 2.0
	self.rect_pivot_offset = self.rect_size / 2.0
	update_multiplier()


func _process(delta: float) -> void:
	self.rect_rotation = sin(Global.time * 1.55) * 3.0
	var default_pos: float = viewport.size.y - 96.0
	self.rect_position.y = default_pos + cos(Global.time * 1.25) * 8.0


func up_multiplier() -> void:
	update_multiplier()
	tween.interpolate_method(self, '_curve_label_scale', 0.0, 1.0, 0.35)
	tween.interpolate_method(self, '_curve_label_rotation', 0.0, 1.0, 0.35)
	tween.start()


func down_multiplier() -> void:
	update_multiplier()
	tween.interpolate_method(self, '_curve_label_scale', 0.0, 1.0, 0.35)
	tween.interpolate_method(self, '_curve_label_rotation', 1.0, -1.0, 0.35)
	tween.start()


func update_multiplier() -> void:
	self.min_value = floor(Global.current_multiplier)
	self.max_value = self.min_value + 1.0
	label.text = 'X' + str(self.min_value)


func set_progress(mult: float) -> void:
	self.value = mult


func _curve_label_scale(t: float) -> void:
	label.rect_scale = Global.float2vec(animation_curve.interpolate(t))
	self.rect_scale = Vector2.ONE + (label.rect_scale - Vector2.ONE) / 3.0


func _curve_label_rotation(t: float) -> void:
	label.rect_rotation = cos(t * 2.0) * 25.0
