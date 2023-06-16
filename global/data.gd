extends Node


signal scores_changed(scores)
signal score_added(scores)

var scores: int = 0 setget set_scores, get_scores


func _ready() -> void:
	pass


func add_score() -> void:
	set_scores(scores + 1)
	emit_signal('score_added', scores)


func set_scores(value: int) -> void:
	scores = value
	emit_signal('scores_changed', scores)


func get_scores() -> int:
	return scores
