extends Node2D

var ballsonscreen
# Called when the node enters the scene tree for the first time.
func _ready():
	ballsonscreen = true
	var viewport_size = get_viewport_rect().size
	# Player setup
	$Player.position = Vector2(viewport_size.x / 2, viewport_size.y - 100)

func _process(delta: float) -> void:
	#Checking if balls are on screen
	var children = get_children()
	for child in children:
		if child.is_in_group("bubbles"):
			ballsonscreen = true
			break
		else:
			ballsonscreen = false
	if ballsonscreen == false and GameManager.won == false:
		GameManager.won = true
	#Game Over
	if GameManager.game_over == true:
		get_tree().paused = true
		$LevelUI/Timer.paused = true
		$LevelUI/TimerLabel.hide()


#tried to check if balls are present only when split() is calles but it doesn't work, probably because queue_free works after the check, thinking of a solution
func _on_ball_check_balls() -> void:
	var children = get_children()
	for child in children:
		if child.is_in_group("bubbles"):
			ballsonscreen = true
			break
		else:
			ballsonscreen = false
	if ballsonscreen == false and GameManager.won == false:
		GameManager.won = true
