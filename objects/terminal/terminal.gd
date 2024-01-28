extends CSGBox3D

@export var active_color : Color = Color(0, 255, 0)
@export var inactive_color : Color = Color(255, 0, 0)
var interactable : bool = false
var active : bool = false

func _ready():
	add_to_group("terminals")

func _on_highlight():
	interactable = true
	$outline.visible = interactable

func _on_unhighlight():
	interactable = false
	$outline.visible = interactable

func connect_interact_signals(player: Node):
	player.highlight.connect(_on_highlight)
	player.unhighlight.connect(_on_unhighlight)
