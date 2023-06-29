extends CanvasLayer


var tween: Tween = Tween.new()

onready var title_label: Label = $Panel/Title


func _ready() -> void:
	self.add_child(tween)
