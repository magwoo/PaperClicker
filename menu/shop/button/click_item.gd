extends ShopButton


onready var points: Label = $Icon/Points


func _ready() -> void:
	update_text()


func press() -> void:
	if Data.scores >= self.item_cost:
		Data.paper_per_click += Data.click_level
		Data.click_level += 1
	update_text()
	.press()


func update_text() -> void:
	points.text = '+{0}'.format([Data.click_level])
