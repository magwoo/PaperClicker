class_name Paper
extends Control


export(float, 0.0, 128.0, 0.5) var move_range: float = 24.0
export(float, 0.0, 5.0, 0.1) var move_speed: float = 2.5
export(float, 0.0, 1.0, 0.05) var rotation_range: float = 0.2
export(float, 0.0, 5.0, 0.1) var rotation_speed: float = 2.25
export(float, 0.0, 5.0, 0.1) var glow_rotation_speed: float = 0.5
export(float, 0.0, 1.0, 0.05) var glow_opacity: float = 0.15
export(float, 0.0, 0.5, 0.01) var glow_opacity_range: float = 0.05
export(PackedScene) var press_number_packed: PackedScene
export(Curve) var animation_curve: Curve

onready var paper: Sprite = $Sprite
onready var shadow: Sprite = $Sprite/Shadow
onready var glow: Sprite = $Glow
onready var button: Button = $Button
onready var player_low: AudioStreamPlayer = $LowPress
onready var player_high: AudioStreamPlayer = $HighPress
onready var tween: Tween = $Tween


func _ready() -> void:
	button.connect('button_down', self, 'press')


func _process(delta: float) -> void:
	var time: float = Global.time
	paper.position.y = sin(time * move_speed) * move_range
	paper.rotation = cos(time * rotation_speed) * rotation_range
	shadow.scale = Vector2.ONE - paper.scale + Global.float2vec(1.075)
	glow.rotate(glow_rotation_speed * delta)
	glow.position.y = paper.position.y
	glow.self_modulate.a = glow_opacity + sin(time * 2.0) * glow_opacity_range
	shadow.rotation = paper.rotation / 3.0


func press() -> void:
	tween.interpolate_method(self, '_curve_sprite_scale', 0.0, 1.0, 0.35)
	Data.add_score(Global.current_multiplier)
	var node: PressNumber = press_number_packed.instance()
	node.rect_position = get_global_mouse_position()
	node.text = '+' + str(Global.current_multiplier)
	Events.emit_signal('spawn_temp_node', node)
	player_high.play()
	player_low.play()
	tween.start()


func _curve_sprite_scale(t: float) -> void:
	paper.scale = Global.float2vec(animation_curve.interpolate(t))
