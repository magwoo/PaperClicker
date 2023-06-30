extends CanvasLayer


const MARGIN: float = 16.0

var tween: Tween = Tween.new()

onready var panel: Panel = $Panel
onready var title_label: Label = $Panel/Title
onready var progress: Panel = $Panel/Progress
onready var viewport: Viewport = self.get_viewport()


func _ready() -> void:
	panel.hide()
	viewport.connect('size_changed', self, 'update_viewport')
	self.add_child(tween)
	yield(self.get_tree().create_timer(1.5), 'timeout')
	open()
	yield(self.get_tree().create_timer(1.5), 'timeout')
	close()


func open() -> void:
	var start_pos: Vector2 = Vector2(
		-panel.rect_size.x, viewport.size.y - panel.rect_size.y - MARGIN
	); var end_pos: Vector2 = Vector2(MARGIN, start_pos.y)
	tween.interpolate_property(
		panel, 'rect_position', start_pos, end_pos,
		0.4, Tween.TRANS_BACK, Tween.EASE_OUT
	); tween.interpolate_property(
		panel, 'modulate', Color.transparent, Color.white, 0.3
	); tween.start(); yield(self.get_tree(), 'idle_frame')
	panel.show()


func close() -> void:
	var end_pos: Vector2 = Vector2(
		-panel.rect_size.x, viewport.size.y - panel.rect_size.y - MARGIN
	); var start_pos: Vector2 = Vector2(MARGIN, end_pos.y)
	tween.interpolate_property(
		panel, 'rect_position', start_pos, end_pos,
		0.4, Tween.TRANS_BACK, Tween.EASE_OUT
	); tween.interpolate_property(
		panel, 'modulate', panel.modulate, Color.transparent, 0.1
	); tween.start()


func set_progress(value: float) -> void:
	pass


func update_viewport() -> void:
	pass
