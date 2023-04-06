extends CanvasLayer

# The HUD in the JumpNRun section and on the Map.

func con(player):
	player.onValueChange.connect(_on_player_on_value_change)

func changeHUD():
	$TXT_Stars.text=str(PlayerData.actual_stars)
	$TXT_Lifes.text=str(PlayerData.actual_lifes)
	$TXT_Coins.text =str(PlayerData.actual_coins)

# when a players value changes, change hud.
func _on_player_on_value_change():
	changeHUD()
