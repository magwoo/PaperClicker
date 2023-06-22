extends Node


signal scores_changed(scores)
signal score_added(scores)

var scores: int = 0 setget set_scores
var paper_per_second: int = 0
var paper_per_click: int = 1
var last_item: int = 0


func _init() -> void:
	SDK.player.connect('player_ready', self, 'load_data')


func _ready() -> void:
	pass


func load_data() -> void:
	scores = SDK.player.get_data('scores', scores)
	paper_per_second = SDK.player.get_data('paper_per_second', paper_per_second)
	paper_per_click = SDK.player.get_data('paper_per_click', paper_per_click)
	last_item = SDK.player.get_data('last_item', last_item)


func sync_data() -> void:
	SDK.player.set_data('paper_per_second', paper_per_second)
	SDK.player.set_data('paper_per_click', paper_per_click)
	SDK.player.set_data('last_item', last_item)
	SDK.player.set_data('scores', scores)
	SDK.player.sync_data()


func add_score(value: int = 1) -> void:
	set_scores(scores + value)
	emit_signal('score_added', scores)


func set_scores(value: int) -> void:
	scores = value
	emit_signal('scores_changed', scores)
