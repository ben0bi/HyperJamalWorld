extends Camera2D

@onready var player=get_tree().root.get_node("/root/Root/Player")

@export var camspeed=100.0

var newy=0

# Called when the node enters the scene tree for the first time.
func _ready():
	position=player.position
	newy=player.position.y
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x = player.position.x
	if player.is_on_floor() or player.is_on_ladder:
		newy=player.position.y
		
	if position.y!=newy:
		position = position.lerp(Vector2(position.x, newy),delta*4.0)
	pass
