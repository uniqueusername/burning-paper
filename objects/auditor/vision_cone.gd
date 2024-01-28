extends RayCast3D

signal retarget

@export var cone_width: float = 30 # degrees
@export var num_rays: int = 30 # even
@export var debug_rays_visible: bool = false
var base_target_pos = Vector3(0, 0, 10)

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
			if collider.get_parent().active:
				retarget.emit(collider.get_parent().global_position)
