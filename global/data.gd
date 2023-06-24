extends Node


signal scores_changed(scores)
signal score_added(scores)

const ITEMS_COUNT: int = 12
const AUTOSAVE_TIME: float = 90.0

var scores: int = 0 setget set_scores
var paper_per_second: int = 0
var paper_per_click: int = 1
var autosave_timer: Timer = Timer.new()
var items: Array = [1]


func _ready() -> void:
	SDK.player.connect('player_ready', self, 'load_data')
	for i in ITEMS_COUNT - 1: items.append(0)
	autosave_timer.connect('timeout', self, 'sync_data')
	self.add_child(autosave_timer)
	autosave_timer.one_shot = true
	autosave_timer.start(AUTOSAVE_TIME)


func load_data() -> void:
	scores = SDK.player.get_data('scores', scores)
	paper_per_second = SDK.player.get_data('paper_per_second', paper_per_second)
	paper_per_click = SDK.player.get_data('paper_per_click', paper_per_click)
	items = SDK.player.get_data('items', items, true)


func wait_sync() -> void:
	autosave_timer.start(1.0)


func sync_data() -> void:
	SDK.player.set_data('paper_per_second', paper_per_second)
	SDK.player.set_data('paper_per_click', paper_per_click)
	SDK.player.set_data('items', items, false, true)
	SDK.player.set_data('scores', scores)
	autosave_timer.start(AUTOSAVE_TIME)
	SDK.player.sync_data()


func add_score(value: int = 1, is_click: bool = true) -> void:
	set_scores(scores + value)
	if is_click: emit_signal('score_added', scores)


func set_scores(value: int) -> void:
	scores = value
	emit_signal('scores_changed', scores)
