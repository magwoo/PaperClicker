extends Node2D


export var move_range: float = 32.0
export var move_speed: float = 2.25
export var rotation_range: float = 0.2
export var rotation_speed: float = 2.0

onready var viewport: Viewport = self.get_viewport()
onready var sprite: Sprite = $Sprite
onready var button: Button = $Button
onready var tween: Tween = $Tween


func _ready() -> void:
	_update_viewport()
	viewport.connect('size_changed', self, '_update_viewport')
	button.connect('button_down', self, 'press')
	button.connect('button_up', self, 'unpress')


func _process(delta: float) -> void:
	sprite.position.y = sin(Global.time * move_speed) * move_range
	sprite.rotation = cos(Global.time * rotation_speed) * rotation_range


func press() -> void:
	tween.interpolate_property(
		sprite, 'scale', sprite.scale, Vector2(0.8, 0.8), 0.125,
		Tween.TRANS_BACK, Tween.EASE_OUT
	); tween.start()


func unpress() -> void:
	tween.interpolate_property(
		sprite, 'scale', sprite.scale, Vector2(1.0, 1.0), 0.125,
		Tween.TRANS_BACK, Tween.EASE_OUT
	); tween.start()


func _update_viewport() -> void:
	self.position = viewport.size / 2.0
	print(viewport.size)
