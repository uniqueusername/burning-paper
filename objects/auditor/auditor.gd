extends Node3D

@onready var default_3d_map_rid: RID = get_world_3d().get_navigation_map()
@onready var terminals = get_tree().get_nodes_in_group("terminals")

@export var target_position: Vector3 = Vector3(0, 0, 0)
@export var floor_offset: float = 0.225
var at_terminal = false
var terminals_last_nearby = 0

var movement_speed: float = 4.0
var movement_delta: float
var path_point_margin: float = 0.5

var current_path_index: int = 0
var current_path_point: Vector3
var current_path: PackedVector3Array

func set_movement_target(target_position: Vector3):

	var start_position: Vector3 = global_transform.origin

	current_path = NavigationServer3D.map_get_path(
		default_3d_map_rid,
		start_position,
		target_position,
		true
	)

	if not current_path.is_empty():
		current_path_index = 0
		current_path_point = current_path[0]

func _physics_process(delta):
	if current_path.is_empty():
		return

	movement_delta = movement_speed * delta

	if global_transform.origin.distance_to(current_path_point) <= path_point_margin:
		current_path_index += 1
		if current_path_index >= current_path.size():
			current_path = []
			current_path_index = 0
			current_path_point = global_transform.origin
			return

	current_path_point = current_path[current_path_index]
	current_path_point.y = floor_offset

	var new_velocity: Vector3 = global_transform.origin.direction_to(current_path_point) * movement_delta

	transform = transform.interpolate_with(transform.looking_at(current_path_point, Vector3(0, 1, 0), true), 0.1)

	global_transform.origin = global_transform.origin.move_toward(global_transform.origin + new_velocity, movement_delta)
	
	if $Area3D.get_overlapping_bodies().size() > terminals_last_nearby:
		at_terminal = true
		
	if at_terminal:
		$hack_timer.start()
		
	terminals_last_nearby = $Area3D.get_overlapping_bodies().size()

func set_new_path():
	var terminal = select_random_terminal()
	while ($Area3D.get_overlapping_bodies().has(terminal)):
		terminal = select_random_terminal()
	set_movement_target(terminal.global_position)

func select_random_terminal():
	return terminals[randi() % terminals.size()]

func _on_timer_timeout():
	set_new_path()

func _on_vision_cone_retarget(target_location: Vector3):
	set_movement_target(target_location)
	
func _on_hack_timer_timeout():
	for body in $Area3D.get_overlapping_bodies():
		if terminals.has(body):
			body.deactivate()
	set_new_path()
	at_terminal = false
