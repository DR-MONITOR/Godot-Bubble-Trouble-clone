extends Control

const heartText = preload("res://assets/pixel-heart-2779422_1280.png") #Heart Texture
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
	add_hearts(GameManager.player_health)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$TimerLabel.text = str(int($Timer.time_left))
	$Score.text = "SCORE: " + str(GameManager.score)
	
	if GameManager.won == true:
		timeLeft = int($Timer.time_left)
		var completionTime = GameManager.time - int($Timer.time_left)
		var bonus = 0
		if timeLeft > GameManager.time - 10:
			bonus = 50
		elif timeLeft > GameManager.time/2:
			bonus = 10
		elif timeLeft > GameManager.time/3:
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
	pass

#removes hearts based on 'amount'
func remove_hearts(amount : int):
	var hearts = $Hearts.get_children()
	var lastHeart = hearts.size() - 1
	if lastHeart < 0:
		return
	for i in amount:
		$Hearts.remove_child(hearts[lastHeart])
		hearts[lastHeart].queue_free()
		lastHeart -= 1


#adds 'n' number of hearts
func add_hearts(n : int):
	for i in n:
		var heart = TextureRect.new()
		heart.set_name(str(i))
		heart.texture = heartText
		$Hearts.add_child(heart)

#called when player is hurt
func _on_player_hurt() -> void:
	remove_hearts(1)

#called when retry button is pressed
func _on_retry_pressed() -> void:
	restart()


#reloads the scene
func restart():
	GameManager.won = false
	GameManager.score = 0
	GameManager.player_health = GameManager.defaultLife
	GameManager.game_over = false
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_timer_timeout() -> void:
	GameManager.game_over = true
