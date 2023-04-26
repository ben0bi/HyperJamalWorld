extends Area2D

# Blocker


func _on_body_entered(body):
	if body.is_in_group("ChangeDirection"):
		body.changeDirection()
	pass # Replace with function body.
