extends Node

@export var interact_distance : int = 2

func _ready():
	%RayCast3D.target_position = Vector3(0, 0, -interact_distance)

func _physics_process(delta):
	if %RayCast3D.is_colliding():
		pass
