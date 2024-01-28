extends Node

signal highlight
signal unhighlight

@export var interact_distance : float = 1

func _ready():
	%RayCast3D.target_position = Vector3(0, 0, -interact_distance)
	get_tree().call_group("terminals", "connect_highlight_signals", self)

func _physics_process(delta):
	if %RayCast3D.is_colliding(): 
		var distance = %RayCast3D.get_collision_point()
		distance = distance.distance_to(get_parent().global_position)
		if distance < interact_distance: highlight.emit()
		else: unhighlight.emit()
	else: unhighlight.emit()
