extends HBoxContainer


onready var viewport: Viewport = self.get_viewport()


func _ready() -> void:
	viewport.connect('size_changed', self, '_update_viewport')
