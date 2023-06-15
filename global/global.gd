extends Node


var time: float = 0.0


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	time += delta


func float2vec(f: float) -> Vector2:
	return Vector2(f, f)
