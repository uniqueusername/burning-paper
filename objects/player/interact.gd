extends Node

signal highlight
signal unhighlight
signal activate

@export var interact_distance: float = 1
var looking_at_terminal: bool = false

func _ready():
	%RayCast3D.target_position = Vector3(0, 0, -interact_distance)
	get_tree().call_group("terminals", "connect_interact_signals", self)

func _physics_process(delta):
	if %RayCast3D.is_colliding(): 
		var distance = %RayCast3D.get_collision_point()
		distance = distance.distance_to(get_parent().global_position)
		if distance < interact_distance: 
			highlight.emit(%RayCast3D.get_collider())
			looking_at_terminal = true
			return
	
	unhighlight.emit()
	looking_at_terminal = false
	
func _input(event):
	if event.is_action_pressed("interact") and looking_at_terminal:
		activate.emit(%RayCast3D.get_collider())
