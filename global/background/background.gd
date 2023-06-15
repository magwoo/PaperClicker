extends CanvasLayer


onready var texture: TextureRect = $Texture
onready var viewport: Viewport = self.get_viewport()


func _ready() -> void:
	viewport.connect('size_changed', self, 'update_viewport')
	update_viewport()


func update_viewport() -> void:
	texture.rect_size = viewport.size
	texture.rect_pivot_offset = texture.rect_size / 2.0
