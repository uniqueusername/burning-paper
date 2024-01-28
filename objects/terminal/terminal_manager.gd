extends Node3D

signal win

@onready var terminals = get_tree().get_nodes_in_group("terminals")
@export var win_count: int = 3

func _process(delta):
	var active_count: int = 0
	for terminal in terminals:
		if terminal.active: active_count += 1
		
	if active_count >= win_count: win.emit()
