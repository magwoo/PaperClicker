extends ShopButton


onready var points: Label = $Icon/Points


func _ready() -> void:
	update_text()


func press() -> void:
	if Data.scores >= self.item_cost:
		Data.paper_per_click += Data.items[self.item_id]
	.press()
	update_text()


func update_text() -> void:
	points.text = '+{0}'.format([Data.items[self.item_id]])
	self.info_tpps.text = '+{0} {1}'.format([Data.items[self.item_id], self.tr('#PPC')])


func get_cost() -> int:
	var cost: float = 100.0
	cost = pow(cost, 1.0 + (Data.items[self.item_id] - 1.0) / 5.0)
	return int(cost)
