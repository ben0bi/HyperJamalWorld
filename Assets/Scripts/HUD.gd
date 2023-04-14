extends CanvasLayer

# The HUD in the JumpNRun section and on the Map.
func _ready():
	print ("HUD initialized.")
	set_process(false)

# must only process on gameover screen.
func _process(delta):
	print("HUD")

# connect the players signals to this hud.
func con(player):
	player.onValueChange.connect(_on_player_on_value_change)
	player.allLifesLost.connect(_on_player_allLifesLost)

# change the HUD values
func changeHUD():
	$TXT_Stars.text=str(PlayerData.actual_stars)
	$TXT_Lifes.text=str(PlayerData.actual_lifes)
	$TXT_Coins.text =str(PlayerData.actual_coins)

# show the gameover popup
func showGameOver():
	$Popup_GameOver.popup_centered()
	print("HUD received Gameover signal.")
	#get_tree().paused = true
	set_process(true)
	set_process_input(true)

# when a players value changes, change hud.
func _on_player_on_value_change():
	changeHUD()

# when the player loses all lifes there is game over.
func _on_player_allLifesLost():
	showGameOver()
