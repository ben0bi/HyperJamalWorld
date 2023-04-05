extends Area2D

# life up collected


func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.addLife()
		self.queue_free()
	pass # Replace with function body.
