extends Area2D

# the weed collectible makes the player big

func _on_body_entered(body):
	if body.is_in_group("Player"):
		if not PlayerData.is_big:
			body.grow()
			self.queue_free()
	pass # Replace with function body.
