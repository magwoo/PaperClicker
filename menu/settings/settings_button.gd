class_name SettingsButton
extends Button


var tween: Tween = Tween.new()

onready var info_panel: Panel = $InfoPanel
onready var info_label: Label = $InfoPanel/Label
onready var focus_player: AudioStreamPlayer = $FocusPlayer
onready var root: SettingsMenu = self.get_tree().get_nodes_in_group('settings_root')[0]


func _ready() -> void:
	self.connect('mouse_entered', self, 'focus')
	self.connect('mouse_exited', self, 'unfocus')
	self.connect('button_down', self, 'press')
	self.connect('button_up', self, 'unpress')
	self.rect_pivot_offset = self.rect_size / 2.0
	info_panel.rect_pivot_offset = info_panel.rect_size / 2.0
	self.add_child(tween)
	unfocus()


func focus() -> void:
	if root.is_opened:
		self.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		focus_player.play()
	tween.interpolate_property(
		self, 'rect_scale', self.rect_scale, Global.f2v(1.1),
		0.1, Tween.TRANS_BACK, Tween.EASE_OUT
	); tween.interpolate_property(
		info_panel, 'rect_position', info_panel.rect_position,
		Vector2(self.rect_size.x + 32.0, 0.0), 0.2, Tween.TRANS_BACK, Tween.EASE_OUT
	); tween.interpolate_property(
		info_panel, 'modulate', info_panel.modulate, Color.white, 0.1
	); tween.start()


func unfocus() -> void:
	self.mouse_default_cursor_shape = Control.CURSOR_ARROW
	tween.interpolate_property(
		self, 'rect_scale', self.rect_scale, Global.f2v(1.0),
		0.1, Tween.TRANS_BACK, Tween.EASE_OUT
	); tween.interpolate_property(
		info_panel, 'rect_position', info_panel.rect_position,
		Vector2(self.rect_size.x * 1.4, 0.0), 0.2, Tween.TRANS_BACK, Tween.EASE_OUT
	); tween.interpolate_property(
		info_panel, 'modulate', info_panel.modulate, Color.transparent, 0.1
	); tween.start()


func press() -> void:
	if !root.is_opened: return
	tween.interpolate_property(
		info_panel, 'rect_scale', info_panel.rect_scale,
		Global.f2v(0.6), 0.2, Tween.TRANS_BACK, Tween.EASE_OUT
	); tween.start()


func unpress() -> void:
	tween.interpolate_property(
		info_panel, 'rect_scale', info_panel.rect_scale,
		Vector2.ONE, 0.2, Tween.TRANS_BACK, Tween.EASE_OUT
	); tween.start()
