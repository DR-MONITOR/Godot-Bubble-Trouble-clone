extends RigidBody2D

@export var size = 3  # 3 = large, 2 = medium, 1 = small
@export var bounciness = 150
var bounce_force = -bounciness / size
@onready var b_texture = $ball_texture  # Make sure this points to a Sprite or TextureRect
@onready var BubbleScene = preload("res://scenes/ball.tscn")
@onready var powerupscene = preload("res://scenes/powerup.tscn")
@onready var healthpowerupscene = preload("res://scenes/heart_powerup.tscn")

func _ready() -> void:
	add_to_group("bubbles")
	setup_bubble_properties()
	$Label.text = str(size)
	set_bouncy_material()

	var last_direction = 100
	var horizontal_direction = last_direction
	last_direction = -last_direction  # Alternate direction
	apply_central_impulse(Vector2(horizontal_direction, bounce_force))

func set_bouncy_material():
	gravity_scale = 0.8
	var physics_material = PhysicsMaterial.new()
	physics_material.bounce = 1.0
	physics_material.friction = 0.0
	physics_material_override = physics_material
	linear_damp = 0.0
	angular_damp = 0.0

func setup_bubble_properties() -> void:
	# Set scale for the main bubble
	var scale_factor = size * 0.5
	scale = Vector2(scale_factor, scale_factor)

	# Adjust the collision shape based on size
	var collision_shape = CollisionShape2D.new()
	var circle_shape = CircleShape2D.new()
	circle_shape.radius = 20 * scale_factor
	collision_shape.shape = circle_shape
	add_child(collision_shape)

	# Debug print to check if b_texture is correctly assigned
	if b_texture:
		b_texture.texture = preload("res://assets/red_ball.png")
		var target_radius = 60 * (size / 3.0)  # Target radius based on size
		var scale_factor2 = target_radius / 120  # Scaling factor based on original radius of 60

		# Apply scale to the texture
		b_texture.scale = Vector2(scale_factor2, scale_factor2)  # Apply scale as Vector2

func split():
	GameManager.score +=100
	if size > 1:
		spawn_smaller_bubbles()
	if randf() < 0.3:
		spawn_power_up()
	queue_free()

func spawn_power_up():
	var power_up_instance
	if randi() % 2 == 0:
		power_up_instance = powerupscene.instantiate()
	else:
		power_up_instance = healthpowerupscene.instantiate()
	power_up_instance.position = position
	get_parent().call_deferred("add_child",power_up_instance)

func spawn_smaller_bubbles() -> void:
	for i in [-1, 1]:
		var new_bubble = BubbleScene.instantiate()
		new_bubble.size = size - 1
		new_bubble.position = position + Vector2(i * 10, 0)

		new_bubble.setup_bubble_properties()
		var bounce_force = -100.0 / new_bubble.size
		new_bubble.apply_central_impulse(Vector2(i * 100, bounce_force * 2))

		get_parent().call_deferred("add_child", new_bubble)
