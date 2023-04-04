extends Node

# GLOBALS

# load the map
func changeToMap():
	get_tree().change_scene_to_file("res://Assets/Scenes/Map.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	# hide the mouse for this game.
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
