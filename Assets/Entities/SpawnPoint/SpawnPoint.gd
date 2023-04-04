extends Area2D

@export var isFirst = false
var alreadyUsed:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_entered(body):
	# if it is the player, maybe set new player spawnpoint
	if body.is_in_group("Player"):
		if not alreadyUsed:
			print("--> SPAWNPOINT SET")
			body.setSpawnPoint(self)
		alreadyUsed=true
	pass # Replace with function body.
