extends Node2D


export var move_range: float = 32.0
export var move_speed: float = 2.0
export var rotation_range: float = 0.3
export var rotation_speed: float = 2.0

onready var viewport: Viewport = self.get_viewport()
onready var sprite: Sprite = $Sprite
onready var tween: Tween = $Tween


func _ready() -> void:
	_update_viewport()
	viewport.connect('size_changed', self, '_update_viewport')


func _process(delta: float) -> void:
	sprite.position.y = sin(Global.time * move_speed) * move_range
	sprite.rotation = cos(Global.time * rotation_speed) * rotation_range


func _update_viewport() -> void:
	self.position = viewport.size / 2.0
