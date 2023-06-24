class_name PressNumber
extends Label


export var gravity: float = 20.0

var velocity: Vector2 = Vector2.ZERO

onready var shadow: Label = $Shadow


func _ready() -> void:
	velocity = Vector2(rand_range(-4.0, 4.0), rand_range(-3.0, -5.0))
	shadow.text = self.text


func _process(delta: float) -> void:
	velocity.y += gravity * delta
	velocity.x = lerp(velocity.x, 0.0, 0.05 * delta * 120.0)
	self.modulate.a -= delta * 1.5
	if modulate.a < 0.0: self.queue_free()
	self.rect_position += velocity
