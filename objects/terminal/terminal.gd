extends CSGBox3D

func _ready():
	add_to_group("terminals")

func _on_highlight():
	$outline.visible = true

func _on_unhighlight():
	$outline.visible = false

func connect_highlight_signals(player: Node):
	player.highlight.connect(_on_highlight)
	player.unhighlight.connect(_on_unhighlight)
