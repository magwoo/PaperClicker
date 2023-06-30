class_name RandomBonus
extends CanvasLayer


const MARGIN: float = 16.0
const CLOSE_DELAY: float = 16.0

var tween: Tween = Tween.new()
var close_timer: Timer = Timer.new()
var bonus_size: int = 120_000_000

onready var panel: Button = $Panel
onready var info_panel: Panel = $Panel/InfoPanel
onready var title_label: Label = $Panel/Title
onready var progress: Panel = $Panel/Progress
onready var viewport: Viewport = self.get_viewport()


func _ready() -> void:
	viewport.connect('size_changed', self, 'update_viewport')
	panel.connect('mouse_entered', self, 'focus')
	panel.connect('mouse_exited', self, 'unfocus')
	panel.connect('button_down', self, 'press')
	panel.connect('button_up', self, 'unpress')
	panel.connect('pressed', self, 'collect_bonus')
	SDK.ads.connect('reward_ad_closed', self, 'reward_ad_closed')
	info_panel.rect_pivot_offset = info_panel.rect_size / 2.0
	close_timer.connect('timeout', self, 'close')
	self.add_child(close_timer)
	self.add_child(tween)
	panel.hide()
	unfocus()
	open()


func _process(delta: float) -> void:
	progress.rect_size.x = panel.rect_size.x * close_timer.time_left / CLOSE_DELAY


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
	close_timer.start(CLOSE_DELAY)
	title_label.text = '+' + Global.cut_number(bonus_size)
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
	tween.connect('tween_all_completed', self, 'queue_free')


func focus() -> void:
	tween.interpolate_property(
		info_panel, 'rect_position', info_panel.rect_position,
		Vector2(info_panel.rect_position.x, -96.0), 0.2,
		Tween.TRANS_BACK, Tween.EASE_OUT
	); tween.interpolate_property(
		info_panel, 'rect_scale', info_panel.rect_scale,
		Global.f2v(1.0), 0.1, Tween.TRANS_BACK, Tween.EASE_OUT
	); tween.interpolate_property(
		info_panel, 'modulate', info_panel.modulate, Color.white, 0.1
	); tween.start()


func unfocus() -> void:
	tween.interpolate_property(
		info_panel, 'rect_position', info_panel.rect_position,
		Vector2(info_panel.rect_position.x, 0.0), 0.2,
		Tween.TRANS_BACK, Tween.EASE_OUT
	); tween.interpolate_property(
		info_panel, 'rect_scale', info_panel.rect_scale,
		Global.f2v(1.2), 0.1, Tween.TRANS_BACK, Tween.EASE_OUT
	); tween.interpolate_property(
		info_panel, 'modulate', info_panel.modulate, Color.transparent, 0.1
	); tween.start()


func press() -> void:
	tween.interpolate_property(
		info_panel, 'rect_scale', info_panel.rect_scale,
		Global.f2v(0.8), 0.1, Tween.TRANS_BACK, Tween.EASE_OUT
	); tween.start()


func unpress() -> void:
	tween.interpolate_property(
		info_panel, 'rect_scale', info_panel.rect_scale,
		Global.f2v(1.0), 0.1, Tween.TRANS_BACK, Tween.EASE_OUT
	); tween.start()


func collect_bonus() -> void:
	Data.reward_id = -2
	SDK.ads.show_reward()
	close_timer.paused = true


func reward_ad_closed(success: bool) -> void:
	if Data.reward_id != -2 || !success:
		close_timer.paused = false
		return
	Data.add_score(bonus_size, true)
	Data.reward_id = -1
	close()


func update_viewport() -> void:
	panel.rect_position.y = viewport.size.y - panel.rect_size.y - MARGIN
