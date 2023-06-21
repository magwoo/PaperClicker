class_name ShopButton
extends Button


const PANEL_SEPARATION: float = 16.0

onready var info_panel: Panel = $InfoPanel
onready var focus_player: AudioStreamPlayer = $FocusPlayer
onready var info_name: Label = $InfoPanel/Name
onready var info_description: Label = $InfoPanel/Description
onready var info_cost: Label = $InfoPanel/Cost
onready var texture: TextureRect = $Icon
onready var tween: Tween = $Tween


func _ready() -> void:
	self.connect('mouse_entered', self, 'focus')
	self.connect('mouse_exited', self, 'unfocus')
	self.connect('button_down', self, 'press')
	self.connect('button_up', self, 'unpress')
	self.rect_pivot_offset = self.rect_size / 2.0
	texture.rect_pivot_offset = texture.rect_size / 2.0
	unfocus()


func setup(settings: ShopItem) -> void:
	info_name.text = settings.name
	info_description.text = settings.description
	info_cost.text = str(settings.cost)


func focus() -> void:
	focus_player.play()
	tween.interpolate_property(
		self, 'rect_scale', self.rect_scale, Global.float2vec(1.15),
		0.2, Tween.TRANS_BACK, Tween.EASE_OUT
	); tween.interpolate_property(
		info_panel, 'rect_position', info_panel.rect_position,
		Vector2(-info_panel.rect_size.x - PANEL_SEPARATION, 0.0),
		0.3, Tween.TRANS_BACK, Tween.EASE_OUT
	); tween.interpolate_property(
		info_panel, 'modulate', info_panel.modulate, Color.white, 0.1
	); tween.start()


func unfocus() -> void:
	tween.interpolate_property(
		self, 'rect_scale', self.rect_scale, Vector2.ONE,
		0.2, Tween.TRANS_BACK, Tween.EASE_OUT
	); tween.interpolate_property(
		info_panel, 'rect_position', info_panel.rect_position,
		Vector2(-info_panel.rect_size.x - PANEL_SEPARATION * 10.0, 0.0),
		0.3, Tween.TRANS_BACK, Tween.EASE_OUT
	); tween.interpolate_property(
		info_panel, 'modulate', info_panel.modulate, Color.transparent, 0.1
	); tween.start()


func press() -> void:
	tween.interpolate_property(
		texture, 'rect_scale', texture.rect_scale, Global.float2vec(0.8),
		0.1, Tween.TRANS_BACK, Tween.EASE_OUT
	); tween.start()


func unpress() -> void:
	tween.interpolate_property(
		texture, 'rect_scale', texture.rect_scale, Vector2.ONE,
		0.1, Tween.TRANS_BACK, Tween.EASE_OUT
	); tween.start()
