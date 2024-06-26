class_name ShopButton
extends Button


const PANEL_SEPARATION: float = 16.0
const LOCKED_ICON: StreamTexture = preload('res://menu/shop/icons/locked.svg')
const GREEN_COLOR: Color = Color(0.639216, 1, 0.560784)
const YELLOW_COLOR: Color = Color(1, 0.962255, 0.560784)
const RED_COLOR: Color = Color(1, 0.560784, 0.560784)

export var item_name: String = 'example name'
export var item_icon: StreamTexture = preload('res://icon.png')
export var item_description: String = 'example description'
export var paper_per_second: int = 0
export var item_id: int = 0
export var item_cost: int = 5

var press_number_packed: PackedScene = preload('res://gameplay/press_number/press_number.tscn')
var ad_timer: Timer = Timer.new()
var is_ad_avaiable: bool = true

onready var info_panel: Panel = $InfoPanel
onready var focus_player: AudioStreamPlayer = $FocusPlayer

onready var info_name: Label = $InfoPanel/Name
onready var info_description: Label = $InfoPanel/Description
onready var info_cost: Label = $InfoPanel/Cost
onready var info_tpps: Label = $InfoPanel/TPPS

onready var texture: TextureRect = $Icon
onready var count_text: Label = $Count
onready var viewport: Viewport = self.get_viewport()
onready var tween: Tween = $Tween


func _ready() -> void:
	self.connect('mouse_entered', self, 'focus')
	self.connect('mouse_exited', self, 'unfocus')
	self.connect('button_down', self, 'press')
	self.connect('button_up', self, 'unpress')
	SDK.ads.connect('reward_ad_closed', self, 'ad_complete')
	Events.connect('update_items', self, 'update_item')
	ad_timer.connect('timeout', self, 'unlock_ad')
	self.rect_pivot_offset = self.rect_size / 2.0
	info_name.text = self.tr(item_name)
	info_tpps.text = '+{0} {1}'.format([Global.cut_number(paper_per_second), self.tr('#PPS')])
	info_description.text = self.tr(item_description)
	count_text.text = 'x%s' % Global.cut_number(Data.items[item_id])
	texture.texture = item_icon
	texture.rect_pivot_offset = texture.rect_size / 2.0
	self.add_child(ad_timer)
	update_item()
	update_cost()
	unfocus()


func _physics_process(delta: float) -> void:
	var cost: int = get_cost()
	if Data.scores >= cost: info_cost.self_modulate = GREEN_COLOR
	elif is_ad_avaiable: info_cost.self_modulate = YELLOW_COLOR
	else: info_cost.self_modulate = RED_COLOR
	update_cost()


func focus() -> void:
	if is_locked(): return
	self.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
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
	); tween.interpolate_property(
		count_text, 'rect_position', count_text.rect_position,
		Vector2(self.rect_size.x - count_text.rect_size.x / 2.0, self.rect_size.y - count_text.rect_size.y),
		0.2, Tween.TRANS_BACK, Tween.EASE_OUT
	); tween.interpolate_property(
		count_text, 'modulate', count_text.modulate, Color.white, 0.1
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
	); tween.interpolate_property(
		count_text, 'rect_position', count_text.rect_position,
		Vector2(self.rect_size.x, self.rect_size.y - count_text.rect_size.y),
		0.2, Tween.TRANS_BACK, Tween.EASE_OUT
	); tween.interpolate_property(
		count_text, 'modulate', count_text.modulate, Color.transparent, 0.1
	);  tween.start()


func press() -> void:
	if is_locked(): return
	if Data.scores < get_cost():
		if is_ad_avaiable:
			SDK.ads.show_reward()
			Data.reward_id = item_id
		else:
			tween.interpolate_method(self, '_sin_rotation', 0.0, PI * 2.0, 0.2)
	else:
		Data.add_score(-get_cost(), false)
		Data.paper_per_second += paper_per_second
		var node: PressNumber = press_number_packed.instance()
		node.rect_position = Vector2(viewport.size.x / 2.0 + 96.0, 64.0)
		node.text = '-%s' % Global.cut_number(get_cost())
		Events.emit_signal('spawn_temp_node', node)
		Data.items[item_id] += 1
		if Data.items[item_id] == 1: Events.emit_signal('update_items')
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


func unlock_ad() -> void:
	is_ad_avaiable = true


func update_cost() -> void:
	var result: String
	if Data.scores < get_cost() && is_ad_avaiable: result = self.tr('#AD')
	else: result = Global.cut_number(get_cost())
	info_cost.text = '{0}: {1}'.format([self.tr('#COST'), result])
	count_text.text = 'x%s' % Global.cut_number(Data.items[item_id])


func update_item() -> void:
	if is_locked(): texture.texture = LOCKED_ICON
	else: texture.texture = item_icon


func is_locked() -> bool:
	return Data.items[max(0, item_id - 1)] == 0


func get_cost() -> int:
	var cost: float = item_id + 1.0
	cost = pow(cost, 1.0 + 0.1 * Data.items[item_id]) * 10.0
	cost = pow(cost, 1.0 + 0.2 * item_id)
	return int(cost)


func ad_complete(success: bool) -> void:
	if Data.reward_id != item_id || !success: return
	Data.items[Data.reward_id] += 1
	if Data.items[item_id] == 1: Events.emit_signal('update_items')
	is_ad_avaiable = false
	ad_timer.start(90.0)
	Data.reward_id = -1
	Data.wait_sync()


func _sin_rotation(t: float) -> void:
	texture.rect_rotation = sin(t) * 8.0
