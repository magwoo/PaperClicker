class_name SettingsButton
extends Button


var tween: Tween = Tween.new()

onready var info_panel: Panel = $InfoPanel
onready var info_text: Label = $InfoPanel/Label


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
	tween.interpolate_property(
		info_panel, 'rect_scale', info_panel.rect_scale,
		Global.f2v(0.6), 0.2, Tween.TRANS_BACK, Tween.EASE_OUT
	); tween.start()


func unpress() -> void:
	tween.interpolate_property(
		info_panel, 'rect_scale', info_panel.rect_scale,
		Vector2.ONE, 0.2, Tween.TRANS_BACK, Tween.EASE_OUT
	); tween.start()
