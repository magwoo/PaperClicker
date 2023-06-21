class_name ShopButton
extends Button


const PANEL_SEPARATION: float = 16.0

export var item_name: String = 'example name'
export var item_icon: StreamTexture = preload('res://icon.png')
export var item_description: String = 'example description'
export var item_cost: int = 5

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
	info_name.text = self.tr(item_name)
	info_description.text = self.tr(item_description)
	info_cost.text = self.tr('#COST') + str(item_cost) + self.tr('#TP')
	texture.texture = item_icon
	texture.rect_pivot_offset = texture.rect_size / 2.0
	unfocus()


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
	if Data.scores < item_cost:
		tween.interpolate_method(self, '_sin_rotation', 0.0, PI * 2.0, 0.2)
	else: Data.add_score(-item_cost)
	tween.interpolate_property(
		texture, 'rect_scale', texture.rect_scale, Global.float2vec(0.8),
		0.1, Tween.TRANS_BACK, Tween.EASE_OUT
	); tween.start()


func unpress() -> void:
	tween.interpolate_property(
		texture, 'rect_scale', texture.rect_scale, Vector2.ONE,
		0.1, Tween.TRANS_BACK, Tween.EASE_OUT
	); tween.start()


func _sin_rotation(t: float) -> void:
	texture.rect_rotation = sin(t) * 15.0
