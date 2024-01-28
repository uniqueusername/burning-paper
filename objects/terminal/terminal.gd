extends CSGBox3D

@export var active_color: Color = Color(0, 1, 0)
@export var inactive_color: Color = Color(1, 0, 0)
var interactable: bool = false
var active: bool = false

func _ready():
	add_to_group("terminals")
	material.albedo_color = inactive_color
	material.emission = inactive_color
	$OmniLight3D.light_color = inactive_color
	
	for child in get_children():
		child.add_to_group("terminal_areas")

func _on_highlight(object: Node):
	if object == self:
		interactable = true
		$outline.visible = interactable

func _on_unhighlight():
	interactable = false
	$outline.visible = interactable
	
func _on_activate(object: Node):
	if object == self and interactable:
		active = true
		material.albedo_color = active_color
		material.emission = active_color
		$OmniLight3D.light_color = active_color
		
func deactivate():
	active = false
	material.albedo_color = inactive_color
	material.emission = inactive_color
	$OmniLight3D.light_color = inactive_color

func connect_interact_signals(player: Node):
	player.highlight.connect(_on_highlight)
	player.unhighlight.connect(_on_unhighlight)
	player.activate.connect(_on_activate)
