extends HBoxContainer


var time: float = 0.0

onready var scores_label: Label = $Gameplay/Scores
onready var gameplay_container: Control = $Gameplay
onready var viewport: Viewport = self.get_viewport()


func _ready() -> void:
	update_scores()
	scores_label.rect_pivot_offset = scores_label.rect_size / 2.0
	viewport.connect('size_changed', self, 'update_viewport')
	Data.connect('scores_changed', self, 'update_scores')
	Data.connect('score_added', self, 'score_added')


func _process(delta: float) -> void:
	scores_label.rect_rotation = lerp(
		scores_label.rect_rotation, sin(time * 3.0) * 9.0, 0.25
	)
	scores_label.rect_scale = lerp(scores_label.rect_scale, Vector2.ONE, 0.25)
	time += delta


func score_added(scores: int) -> void:
	scores_label.rect_scale += Vector2(0.4, 0.4)
	time += rand_range(0.25, 0.5)


func update_scores(scores: int = -1) -> void:
	scores_label.text = str(scores) if scores > -1 else str(Data.get_scores())


func update_viewport() -> void:
	gameplay_container.rect_min_size.y = viewport.size.y
