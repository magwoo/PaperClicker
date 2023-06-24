class_name Game
extends HBoxContainer


export var press_number_packed: PackedScene

var time: float = 0.0
var multiplier: float = 1.0
var second_timer: Timer = Timer.new()

onready var scores_label: Label = $Gameplay/Scores
onready var gameplay_container: Control = $Gameplay
onready var multiplier_bar: MultiplierBar = $Gameplay/MultiplierBar
onready var viewport: Viewport = self.get_viewport()


func _ready() -> void:
	scores_label.rect_pivot_offset = scores_label.rect_size / 2.0
	viewport.connect('size_changed', self, 'update_viewport')
	Data.connect('scores_changed', self, 'update_scores')
	Data.connect('score_added', self, 'score_added')
	second_timer.connect('timeout', self, '_second')
	self.add_child(second_timer)
	second_timer.start(1.0)
	update_scores(Data.scores)


func _process(delta: float) -> void:
	scores_label.rect_rotation = lerp(
		scores_label.rect_rotation, sin(time * 3.0) * 9.0, 0.25 * delta * 120.0
	); scores_label.rect_scale = lerp(
		scores_label.rect_scale, Vector2.ONE, 0.25 * delta * 120.0
	)

	if multiplier > Global.current_multiplier + 1:
		Global.current_multiplier += 1
		multiplier_bar.up_multiplier()
		multiplier += 0.05
	if multiplier < Global.current_multiplier:
		Global.current_multiplier -= 1
		multiplier_bar.down_multiplier()

	multiplier_bar.set_progress(multiplier)

	var delta_mult: float = 20.0 / Global.current_multiplier
	multiplier = max(1.0, multiplier - delta / delta_mult)

	time += delta


func score_added(scores: int, is_click: bool = true) -> void:
	scores_label.rect_scale += Vector2(0.4, 0.4)
	if is_click: multiplier += 0.075
	time += rand_range(0.25, 0.5)


func update_scores(scores: int = -1) -> void:
	scores_label.text = Global.cut_number(scores)


func update_viewport() -> void:
	gameplay_container.rect_min_size.y = viewport.size.y


func _second() -> void:
	if Data.paper_per_second == 0: return
	Data.add_score(Data.paper_per_second, false)
	score_added(0, false)
	var node: PressNumber = press_number_packed.instance()
	node.rect_position = Vector2(viewport.size.x / 2.0 + 96.0, 64.0)
	node.text = '+%s' % Global.cut_number(Data.paper_per_second)
	Events.emit_signal('spawn_temp_node', node)
