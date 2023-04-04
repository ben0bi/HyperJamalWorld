extends Area2D

# player picks up the coin
func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.addCoin()
		self.queue_free()
