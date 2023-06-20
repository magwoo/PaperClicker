extends Node


func _ready() -> void:
	Events.connect('spawn_temp_node', self, 'spawn_temp_node')


func spawn_temp_node(node: Node) -> void:
	self.add_child(node)
