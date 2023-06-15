extends Node2D


export var move_range: float = 32.0
export var move_speed: float = 2.25
export var rotation_range: float = 0.2
export var rotation_speed: float = 2.0
export var scale_multiply: float = 0.2
export(Curve) var animation_curve: Curve

var sprite_scale_progress: float = 0.0

onready var viewport: Viewport = self.get_viewport()
onready var sprite: Sprite = $Sprite
onready var button: Button = $Button
onready var tween: Tween = $Tween


func _ready() -> void:
	viewport.connect('size_changed', self, '_update_viewport')
	button.connect('button_down', self, 'press')
	button.connect('button_up', self, 'unpress')
	_update_viewport()


func _process(delta: float) -> void:
	sprite.position.y = sin(Global.time * move_speed) * move_range
	sprite.rotation = cos(Global.time * rotation_speed) * rotation_range
	sprite.scale = Vector2.ONE - Global.float2vec(
		animation_curve.interpolate(sprite_scale_progress) * scale_multiply
	)


func press() -> void:
	tween.interpolate_property(
		self, 'sprite_scale_progress', sprite_scale_progress, 1.0, 0.1
	); tween.start()


func unpress() -> void:
	tween.interpolate_property(
		self, 'sprite_scale_progress', sprite_scale_progress, 0.0, 0.1
	); tween.start()


func _update_viewport() -> void:
	self.position = viewport.size / 2.0
	print(viewport.size)
