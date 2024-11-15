extends Control

const heartText = preload("res://assets/pixel-heart-2779422_1280.png") # Heart Texture
var timeLeft

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TimerLabel.show()
	$Timer.wait_time = GameManager.time
	$Timer.start()
	GameManager.timeout = false
	GameManager.player_health = GameManager.defaultLife
	GameManager.score = 0
	$FinalScore.text = ""
	$Score.text = "SCORE: " + str(GameManager.score)
	$Retry.hide()
	$GameOver.hide()
	$Won.hide()
	$Replay.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$TimerLabel.text = str(int($Timer.time_left))
	$Score.text = "SCORE: " + str(GameManager.score)
	update_hearts(GameManager.player_health)
	if GameManager.won == true:
		timeLeft = int($Timer.time_left)
		var completionTime = GameManager.time - int($Timer.time_left)
		var bonus = 0
		if timeLeft > GameManager.time - 10:
			bonus = 50
		elif timeLeft > GameManager.time / 2:
			bonus = 10
		elif timeLeft > GameManager.time / 3:
			bonus = 5
		var finalscore = GameManager.score + GameManager.player_health + bonus
		$Won.show()
		$Replay.show()
		$Timer.paused = true
		$TimerLabel.hide()
		$FinalScore.text = "LIFE: " + str(GameManager.player_health) + "\nSCORE: " + str(GameManager.score) + "\nCOMPLETION TIME: " + str(completionTime) + " seconds" + "\nBONUS FOR SPEED: " + str(bonus) + "\nFINAL SCORE: " + str(finalscore)

	if GameManager.game_over == true:
		$GameOver.show()
		$Retry.show()

# Updates the hearts based on the player's current health
func update_hearts(current_health: int):
	var hearts = $Hearts.get_children()
	var current_heart_count = hearts.size()
	
	if current_heart_count < current_health:
		add_hearts(current_health - current_heart_count)
	elif current_heart_count > current_health:
		remove_hearts(current_heart_count - current_health)

# Removes hearts based on 'amount'
func remove_hearts(amount: int):
	var hearts = $Hearts.get_children()
	var last_heart = hearts.size() - 1
	if last_heart < 0:
		return
	for i in range(amount):
		$Hearts.remove_child(hearts[last_heart])
		hearts[last_heart].queue_free()
		last_heart -= 1

# Adds 'n' number of hearts
func add_hearts(n: int):
	for i in range(n):
		var heart = TextureRect.new()
		heart.texture = heartText
		$Hearts.add_child(heart)

# Called when player is hurt
func _on_player_hurt() -> void:
	GameManager.player_health -= 1
	update_hearts(GameManager.player_health)

# Called when retry button is pressed
func _on_retry_pressed() -> void:
	restart()

# Reloads the scene
func restart():
	GameManager.won = false
	GameManager.score = 0
	GameManager.player_health = GameManager.defaultLife
	GameManager.game_over = false
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_timer_timeout() -> void:
	GameManager.game_over = true
