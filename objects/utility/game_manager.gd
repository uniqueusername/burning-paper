extends Node

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

	if event.is_action_pressed("ui_reset"):
		get_tree().reload_current_scene()

func get_player_or_null():
	return get_node_or_null("player")
