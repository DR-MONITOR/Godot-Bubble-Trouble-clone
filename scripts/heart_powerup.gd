extends Area2D
@export var powerupspeed: float = 50
@onready var player_health = preload("res://scripts/global scripts/game_manager.gd")
var collect = false

func _physics_process(delta: float) -> void:
	position.y += powerupspeed*delta
	
	



func _on_body_entered(_body: Node2D) -> void:
	if GameManager.player_health and collect == false:
		GameManager.player_health += 1  # Increase health
		collect = true
		print("Player Health:", GameManager.player_health)
		queue_free() 
