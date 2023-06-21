extends Node


var time: float = 0.0
var current_multiplier: int = 1

var cut_chars: Array = ['K', 'M', 'B', 'T', 'Q']


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	time += delta


func cut_number(number: float) -> String:
	var number_size: int = 0
	while number >= 1000.0:
		number /= 1000.0
		number_size += 1

	if number < 10: number = floor(number * 100.0) / 100.0
	else: number = floor(number * 10.0) / 10.0

	if number_size == 0: return str(floor(number))
	elif number_size > cut_chars.size():
		return str('> 999.9' + cut_chars[cut_chars.size() - 1])

	return str(number) + cut_chars[number_size-1]


func f2v(f: float) -> Vector2:
	return Vector2(f, f)
