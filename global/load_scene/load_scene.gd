extends Control


var tween: Tween = Tween.new()

onready var logo: TextureRect = $Logo
onready var viewport: Viewport = self.get_viewport()


func _ready() -> void:
	viewport.connect('size_changed', self, 'update_viewport')
	self.add_child(tween)
	animate()


func animate() -> void:
	var start_pos: Vector2 = viewport.size / 2.0
	var end_pos: Vector2 = start_pos - Vector2(0.0, 48.0)
	tween.interpolate_property(
		logo, 'rect_position', start_pos, end_pos,
		0.3, Tween.TRANS_BACK, Tween.EASE_OUT, 0.5
	); tween.interpolate_property(
		logo, 'modulate', Color.transparent, Color.white,
		0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.6
	); tween.start()


func update_viewport() -> void:
	pass
