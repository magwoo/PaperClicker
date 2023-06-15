extends Control


export var move_range: float = 24.0
export var move_speed: float = 2.5
export var rotation_range: float = 0.2
export var rotation_speed: float = 2.25
export var glow_rotation_speed: float = 0.5
export(Curve) var animation_curve: Curve

onready var sprite: Sprite = $Sprite
onready var shadow: Sprite = $Sprite/Shadow
onready var glow: Sprite = $Glow
onready var button: Button = $Button
onready var tween: Tween = $Tween


func _ready() -> void:
	button.connect('button_down', self, 'press')


func _process(delta: float) -> void:
	sprite.position.y = sin(Global.time * move_speed) * move_range
	sprite.rotation = cos(Global.time * rotation_speed) * rotation_range
	shadow.scale = Vector2.ONE - sprite.scale + Global.float2vec(1.075)
	glow.rotate(glow_rotation_speed * delta)
	glow.position.y = sprite.position.y
	shadow.rotation = sprite.rotation / 3.0


func press() -> void:
	tween.interpolate_method(self, '_curve_sprite_scale', 0.0, 1.0, 0.35)
	tween.start()


func _curve_sprite_scale(t: float) -> void:
	sprite.scale = Global.float2vec(animation_curve.interpolate(t))
