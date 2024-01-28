extends Node3D

@onready var terminals = get_tree().get_nodes_in_group("terminals")

func _process(delta):
	var active_count: int = 0
	for terminal in terminals:
		if terminal.active: active_count += 1
