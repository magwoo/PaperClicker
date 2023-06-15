extends Sprite


onready var viewport: Viewport = self.get_viewport()


func _ready() -> void:
	self.position = viewport.size / 2.0
