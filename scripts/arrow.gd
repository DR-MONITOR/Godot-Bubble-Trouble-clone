extends Area2D

# Signal to notify when the arrow is out of bounds
signal out_of_bounds

# Define a velocity property for the arrow
var velocity = Vector2.ZERO
var vel_multiplier = 2


func _physics_process(delta):
	# Move the arrow based on its velocity
	position += velocity * delta * vel_multiplier

func _on_body_entered(body):
	if body.is_in_group("bubbles") and body.has_method("split"):
		self.queue_free()
		emit_signal("out_of_bounds")
		body.split()
	pass # Replace with function body.


func _on_visible_on_screen_notifier_2d_screen_exited():
	emit_signal("out_of_bounds")
	queue_free()  # Optionally remove the bubble if it's out of bounds
