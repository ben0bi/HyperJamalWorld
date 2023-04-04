extends CanvasLayer

# show a popup which shows how much stars are needed.
func showMoreStarsNeeded(howmany):
	$MoreStarsNeeded/Text.text = "+"+str(howmany)+" Stars needed."
	if howmany==1:
		$MoreStarsNeeded/Text.text = "+1 Star needed."
	$MoreStarsNeeded.popup_centered()
	$PopupTimer.start()

# hide all popups
func _on_popup_timer_timeout():
	$MoreStarsNeeded.hide()
