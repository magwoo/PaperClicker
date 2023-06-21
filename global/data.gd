extends Node


signal scores_changed(scores)
signal score_added(scores)

const ITEMS_COUNT: int = 12

var scores: int = 0 setget set_scores, get_scores
var open_items: Array = []


func _ready() -> void:
	for i in ITEMS_COUNT: open_items.append(0)


func add_score(value: int = 1) -> void:
	set_scores(scores + value)
	emit_signal('score_added', scores)


func set_scores(value: int) -> void:
	scores = value
	emit_signal('scores_changed', scores)


func get_scores() -> int:
	return scores
