class_name ShopButton
extends Button


const PANEL_SEPARATION: float = 16.0

onready var info_panel: Panel = $Panel
onready var tween: Tween = $Tween


func _ready() -> void:
	self.connect('mouse_entered', self, 'focus')
	self.connect('mouse_exited', self, 'unfocus')
	unfocus()


func focus() -> void:
	tween.interpolate_property(
		info_panel, 'rect_position', info_panel.rect_position,
		Vector2(0.0, -info_panel.rect_size.x - PANEL_SEPARATION),
		0.1, Tween.TRANS_BACK, Tween.EASE_OUT
	); tween.interpolate_property(
		info_panel, 'modulate', info_panel.modulate, Color.white, 0.1
	); tween.start()


func unfocus() -> void:
	tween.interpolate_property(
		info_panel, 'rect_position', info_panel.rect_position,
		Vector2(0.0, -info_panel.rect_size.x - PANEL_SEPARATION * 10.0),
		0.1, Tween.TRANS_BACK, Tween.EASE_OUT
	); tween.interpolate_property(
		info_panel, 'modulate', info_panel.modulate, Color.transparent, 0.1
	); tween.start()
