extends CharacterBody2D


var SPEED = 300.0
const JUMP_VELOCITY = -400.0
const GRAVITY = 980.0
@onready var anim = $AnimatedSprite2D
@onready var can_shoot = true
@onready var ArrowScene = preload("res://scenes/arrow.tscn")  # Ensure this path points to your arrow scene

# Declare an invincibility flag and a reference to the Timer node
var is_invincible = false
@onready var invincibility_timer = $Timer

func _physics_process(delta):
	# Apply gravity
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	# Handle jump and shooting
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and can_shoot:
		shoot()

	# Get input direction and handle movement
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = 0

	# Play animation and handle flipping based on direction
	if direction != 0:
		anim.play("Walk_right")
		anim.flip_h = direction < 0  # Flip horizontally when moving left
	else:
		anim.play("Stop")
		anim.frame = 0  # Optional: Reset to the first frame when idle

	# Move and clamp position
	move_and_slide()

func shoot():
	if can_shoot:
		# Instantiate the arrow scene
		var arrow_instance = ArrowScene.instantiate()
		
		# Set the position of the arrow to the player's position
		arrow_instance.global_position = global_position
		arrow_instance.global_position.y = global_position.y + 20
		# Set the arrow's velocity to move it straight up
		arrow_instance.velocity = Vector2(0, -500)
		
		# Connect the arrow's out_of_bounds signal to re-enable shooting
		arrow_instance.connect("out_of_bounds", Callable(self, "_on_arrow_out_of_bounds"))
		
		# Add the arrow instance to the scene tree
		get_parent().add_child(arrow_instance)
		
		# Disable shooting temporarily
		can_shoot = false

# Callback to re-enable shooting when the arrow goes out of bounds
func _on_arrow_out_of_bounds():
	can_shoot = true

func _on_hitbox_body_entered(body):
	if body.is_in_group("bubbles") and not is_invincible:
		if GameManager.player_health > 0:
			GameManager.player_health -= 1
			print("Player Health:", GameManager.player_health)
			
			# Trigger invincibility and start the timer
			is_invincible = true
			invincibility_timer.start()
			
			# Check if health has reached zero
			if GameManager.player_health == 0:
				GameManager.game_over = true

func _on_timer_timeout():
	is_invincible = false
