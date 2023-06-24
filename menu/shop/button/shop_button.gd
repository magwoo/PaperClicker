class_name ShopButton
extends Button


const PANEL_SEPARATION: float = 16.0
const LOCKED_ICON: StreamTexture = preload('res://menu/shop/icons/locked.svg')

export var item_name: String = 'example name'
export var item_icon: StreamTexture = preload('res://icon.png')
export var item_description: String = 'example description'
export var paper_per_second: int = 0
export var item_id: int = 0
export var item_cost: int = 5
export var press_number_packed: PackedScene

onready var info_panel: Panel = $InfoPanel
onready var focus_player: AudioStreamPlayer = $FocusPlayer

onready var info_name: Label = $InfoPanel/Name
onready var info_description: Label = $InfoPanel/Description
onready var info_cost: Label = $InfoPanel/Cost

onready var texture: TextureRect = $Icon
onready var viewport: Viewport = self.get_viewport()
onready var tween: Tween = $Tween


func _ready() -> void:
	self.connect('mouse_entered', self, 'focus')
	self.connect('mouse_exited', self, 'unfocus')
	self.connect('button_down', self, 'press')
	self.connect('button_up', self, 'unpress')
	self.rect_pivot_offset = self.rect_size / 2.0
	info_name.text = self.tr(item_name)
	info_description.text = self.tr(item_description)
	texture.texture = item_icon
	texture.rect_pivot_offset = texture.rect_size / 2.0
	update_cost()
	unfocus()


func focus() -> void:
	focus_player.play()
	tween.interpolate_property(
		self, 'rect_scale', self.rect_scale, Global.f2v(1.15),
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
	if Data.scores < get_cost():
		tween.interpolate_method(self, '_sin_rotation', 0.0, PI * 2.0, 0.2)
	else:
		Data.add_score(-get_cost(), false)
		Data.paper_per_second += paper_per_second
		var node: PressNumber = press_number_packed.instance()
		node.rect_position = Vector2(viewport.size.x / 2.0 + 96.0, 64.0)
		node.text = '-%s' % Global.cut_number(get_cost())
		Events.emit_signal('spawn_temp_node', node)
		Data.items[item_id] += 1
		Data.wait_sync()
		update_cost()
	tween.interpolate_property(
		texture, 'rect_scale', texture.rect_scale, Global.f2v(0.8),
		0.1, Tween.TRANS_BACK, Tween.EASE_OUT
	); tween.start()


func unpress() -> void:
	tween.interpolate_property(
		texture, 'rect_scale', texture.rect_scale, Vector2.ONE,
		0.1, Tween.TRANS_BACK, Tween.EASE_OUT
	); tween.start()


func update_cost() -> void:
	info_cost.text = '{0}: {1}'.format(
		[self.tr('#COST'), Global.cut_number(get_cost())]
	);


func get_cost() -> int:
	var cost: float = item_id + 1.0
	cost = pow(cost, 1.0 + 0.1 * Data.items[item_id]) * 10.0
	cost = pow(cost, 1.0 + 0.3 * item_id)
	return int(cost)


func _sin_rotation(t: float) -> void:
	texture.rect_rotation = sin(t) * 8.0
