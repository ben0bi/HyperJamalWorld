extends CharacterBody2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = 1
@export var Speed = 100

var hit_player=false

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# reverse direction if a wall was hit
	if is_on_wall():
		direction= -direction#	print("ENEMY ON WALL")
	
	# check if player gets a hit or 
	# player hits this from above.
	var playerfound = false
	for i in range(get_slide_collision_count()):
		var collision=get_slide_collision(i)
		if collision.get_collider()==null:
			continue
		if collision.get_collider().is_in_group("Player"):
			var player= collision.get_collider()
			playerfound = true
			if Vector2.DOWN.dot(collision.get_normal())>0.1:
				print("PLAYER HITS ENEMY")
				queue_free()
			else:
				# it may hit the player more than once
				if not hit_player:
					player.hit()
					hit_player=true
					print("ENEMY HITS PLAYER")
	
	# reset player hit detected
	if not playerfound:
		hit_player = false
	
	velocity.x = direction * Speed

	move_and_slide()
