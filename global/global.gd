extends Node


var time: float = 0.0
var current_multiplier: int = 1
var bonus_timer: Timer = Timer.new()
var bonus_packed: PackedScene = load('res://menu/random_bonus/random_bonus.tscn')

var cut_chars: Array = ['K', 'M', 'B', 'T', 'Q']


func _init() -> void:
	randomize()


func _ready() -> void:
	SDK.ads.connect('any_ad_started', self, 'mute')
	SDK.ads.connect('any_ad_closed', self, 'unmute')
	bonus_timer.connect('timeout', self, 'open_bonus_window')
	self.add_child(bonus_timer)
	bonus_timer.one_shot = true
	bonus_timer.start(rand_range(30.0, 120.0))


func _process(delta: float) -> void:
	time += delta


func open_bonus_window() -> void:
	var bonus_scene: RandomBonus = bonus_packed.instance()
	bonus_scene.bonus_size = int(Data.scores * rand_range(0.8, 5.0))
	bonus_timer.start(rand_range(45.0, 120.0))
	self.add_child(bonus_scene)


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


func mute() -> void:
	AudioServer.set_bus_mute(0, true)


func unmute() -> void:
	AudioServer.set_bus_mute(0, false)
