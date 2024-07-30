extends Node2D

@export var node: Node2D

func _process(delta: float) -> void:
	var _node = node if node else self
	_node.rotation += 0.5 * delta
