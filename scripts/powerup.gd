extends Area2D

@export var powerup_speed: float = 50
@export var boosted_speed: float = 575  # Boosted speed value
@export var default_speed: float = 500  # Default speed value for the player
var collect = false
var is_on_floor = false

@onready var power_timer = $Timer

func _physics_process(delta: float) -> void:
	# Only move downwards if the power-up hasn't landed on the floor yet
	if not is_on_floor:
		position.y += powerup_speed * delta

func _on_body_entered(body: Node) -> void:
	# Check if the body is the player and the power-up hasn't been collected
	if body.is_class("CharacterBody2D") and not collect:
		collect = true  # Mark as collected to avoid duplicate triggering
		body.SPEED = boosted_speed  # Apply boosted speed to the player
		power_timer.start()  # Start timer for power-up duration
		queue_free()  # Remove the power-up from the scene

	# Check if the power-up has landed on the floor
	elif body.is_in_group("floors"):
		is_on_floor = true  # Mark as landed to stop moving

func _on_timer_timeout() -> void:
	# Find the player node within the scene to reset the speed
	var player = get_parent().get_node_or_null("Player")
	if player and player.is_class("CharacterBody2D"):
		player.SPEED = default_speed  # Reset speed to default after power-up duration
