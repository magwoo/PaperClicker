extends CanvasLayer


onready var shader: TextureRect = $Shader
onready var viewport: Viewport = self.get_viewport()


func _ready() -> void:
	viewport.connect('size_changed', self, 'update_viewport')
	update_viewport()


func update_viewport() -> void:
	shader.rect_size = viewport.size
	shader.rect_pivot_offset = shader.rect_size / 2.0
