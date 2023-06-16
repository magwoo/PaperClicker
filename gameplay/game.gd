class_name Game
extends HBoxContainer


var time: float = 0.0
var multiplier: float = 1.0

onready var scores_label: Label = $Gameplay/Scores
onready var gameplay_container: Control = $Gameplay
onready var multiplier_bar: MultiplierBar = $Gameplay/MultiplierBar
onready var viewport: Viewport = self.get_viewport()


func _ready() -> void:
	scores_label.rect_pivot_offset = scores_label.rect_size / 2.0
	viewport.connect('size_changed', self, 'update_viewport')
	Data.connect('scores_changed', self, 'update_scores')
	Data.connect('score_added', self, 'score_added')
	update_scores()


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


func score_added(scores: int) -> void:
	scores_label.rect_scale += Vector2(0.4, 0.4)
	multiplier += 0.075
	time += rand_range(0.25, 0.5)


func update_scores(scores: int = -1) -> void:
	scores_label.text = str(scores) if scores > -1 else str(Data.get_scores())


func update_viewport() -> void:
	gameplay_container.rect_min_size.y = viewport.size.y
