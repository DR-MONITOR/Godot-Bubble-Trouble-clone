extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var viewport_size = get_viewport_rect().size

	# Player setup
	$Player.position = Vector2(viewport_size.x / 2, viewport_size.y - 100)
