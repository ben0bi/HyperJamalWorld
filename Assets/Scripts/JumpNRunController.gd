extends Node2D

@onready var root = get_tree().root.get_node("/root/Root")
@onready var player = get_tree().root.get_node("/root/Root/Player")
@onready var spawnpoints = get_tree().root.get_node("/root/Root/SpawnPoints")

# Called when the node enters the scene tree for the first time.
func _ready():
	# create and connect HUD
	var hudfile = load("res://Assets/Scenes/HUD.tscn")
	var hud = hudfile.instantiate()
	root.add_child(hud)
	hud.con(player)
	# initialize HUD by sending signal
	player.onValueChange.emit()
	
	# create camera and background
	var camerafile = load("res://Assets/Scenes/camera.tscn")
	var cam = camerafile.instantiate()
	root.add_child(cam)
	# move the camera to index 0 in the tree so
	# that the background is really in the background.
	root.move_child(cam,0)

	# prepare player
	player.setAnimation("right_idle")
	
	# set player to first spawnpoint position
	for s in spawnpoints.get_children():
		if s.isFirst:
			player.setSpawnPoint(s)
			player.position=s.position
	
	# make big if player is big
	if PlayerData.is_big:
		player.grow()
