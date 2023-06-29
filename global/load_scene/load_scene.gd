extends Control


var tween: Tween = Tween.new()

onready var logo: TextureRect = $Logo
onready var viewport: Viewport = self.get_viewport()


func _ready() -> void:
	viewport.connect('size_changed', self, 'update_viewport')
	tween.connect('tween_all_completed', self, 'complete')
	logo.rect_pivot_offset = logo.rect_size / 2.0
	logo.modulate.a = 0.0
	self.add_child(tween)
	animate()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion && Input.is_mouse_button_pressed(1):
		logo.rect_position += event.relative


func animate() -> void:
	var start_pos: Vector2 = viewport.size / 2.0 - logo.rect_size / 2.0
	var end_pos: Vector2 = start_pos - Vector2(0.0, 64.0)
	tween.interpolate_property(
		logo, 'rect_position', start_pos, end_pos,
		0.4, Tween.TRANS_BACK, Tween.EASE_OUT, 0.9
	); tween.interpolate_property(
		logo, 'modulate', Color.transparent, Color.white,
		0.3, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.9
	); tween.start()


func complete() -> void:
	while !SDK.player.is_ready():
		yield(get_tree().create_timer(0.05), 'timeout')
	yield(get_tree().create_timer(0.5), 'timeout')
	Music.play()
	self.get_tree().change_scene('res://gameplay/game.tscn')


func update_viewport() -> void:
	pass
