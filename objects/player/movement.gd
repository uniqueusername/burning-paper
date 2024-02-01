extends CharacterBody3D

signal die

const WALK = 3.0
const SPRINT = 10.0
var speed = WALK
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.001
#bob variables
const BOB_FREQ = 2.0
const BOB_AMP = 0.08
var t_bob = 0.0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var dead = false

@onready var head = $head
@onready var camera = $head/Camera3D

#no cursor
func _ready():
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		$AudioStreamPlayer3D.volume_db = -12
		 
#camera movement
func _unhandled_input(event):
	if not dead and event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))
func _physics_process(delta):
	if dead:
		return
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	#handle sprint
	
	#if Input.is_action_pressed ("sprint"):
		#speed = SPRINT
	#else:
		#speed = WALK

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		if not $AudioStreamPlayer3D.playing:
			$AudioStreamPlayer3D.play(0.14)
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		if $AudioStreamPlayer3D.playing:
			$AudioStreamPlayer3D.stop()
		velocity.x = lerp(velocity.x, direction.x *speed, delta * 10.0)
		velocity.z = lerp(velocity.z, direction.z *speed, delta * 10.0)
#head bob 
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	move_and_slide()
	
#inertia

	

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time + BOB_FREQ) * BOB_AMP 
	pos.y = cos(time + BOB_FREQ/2) * BOB_AMP
	return pos

func kill(location):
	dead = true
	camera.look_at(location + Vector3(0, 1, 0))
	die.emit()
