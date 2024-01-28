extends RayCast3D

signal retarget

@onready var terminals = get_tree().get_nodes_in_group("terminals")
@onready var terminal_scanner = get_parent().get_node("terminal_scanner")
@onready var terminal_areas = get_tree().get_nodes_in_group("terminal_areas")
@export var cone_width: float = 30 # degrees
@export var num_rays: int = 30 # even
@export var debug_rays_visible: bool = false
var base_target_pos: Vector3 = Vector3(0, 0, 10)
var player_in_los: bool = false
var tracking: bool = false

func _ready():
	$RayCast3D.visible = debug_rays_visible
	$RayCast3D2.visible = debug_rays_visible
	
func _physics_process(delta):
	# visualization rays
	$RayCast3D.target_position = base_target_pos.rotated(Vector3.UP, deg_to_rad(cone_width))
	$RayCast3D2.target_position = base_target_pos.rotated(Vector3.UP, -deg_to_rad(cone_width))
	
	# lidar ray
	target_position = base_target_pos
	target_position = target_position.rotated(Vector3.UP, deg_to_rad(cone_width))

	for i in num_rays:
		target_position = target_position.rotated(Vector3.UP, -2*deg_to_rad(cone_width/num_rays))
		force_raycast_update()
		if is_colliding():
			var collider = get_collider()
			
			# spotted player
			if collider == %player:
				player_in_los = true
				retarget.emit(%player.global_position)
				return
				
			if player_in_los:
				player_in_los = false
				tracking = true
				var bodies = terminal_scanner.get_overlapping_bodies()
				if terminal_scanner.has_overlapping_bodies():
					retarget.emit(bodies[randi() % bodies.size()])
					return
				else:
					retarget.emit(terminals[randi() % terminals.size()])
					return
			
			# spotted hacked terminal
			if (terminal_areas.has(collider) and
				collider.get_parent().active and
				not tracking):
				retarget.emit(collider.get_parent().global_position)

func _on_end_tracking():
	tracking = false
