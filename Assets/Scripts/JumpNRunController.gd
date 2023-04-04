extends Node2D

@onready var player = get_tree().root.get_node("/root/Root/Player")
@onready var spawnpoints = get_tree().root.get_node("/root/Root/SpawnPoints")

# Called when the node enters the scene tree for the first time.
func _ready():
	player.setAnimation("right_idle")
	
	# set player to first spawnpoint position
	for s in spawnpoints.get_children():
		if s.isFirst:
			player.setSpawnPoint(s)
			player.position=s.position
	
	# make big if player is big
	if PlayerData.is_big:
		player.grow()
	pass # Replace with function body.
