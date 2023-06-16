extends HBoxContainer


onready var scores_label: Label = $Gameplay/Scores
onready var viewport: Viewport = self.get_viewport()


func _ready() -> void:
	update_scores()
	Data.connect('scores_changed', self, 'update_scores')
	Data.connect('score_added', self, 'score_added')


func score_added(scores: int) -> void:
	pass


func update_scores(scores: int = -1) -> void:
	scores_label.text = str(scores) if scores > -1 else str(Data.get_scores())
