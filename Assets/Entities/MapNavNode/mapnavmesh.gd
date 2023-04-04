extends Node2D

@export var ID:int
@export var stop:bool = true
@export var stars_needed:int = 0
@export var node_left_ID:int
@export var node_right_ID:int
@export var node_up_ID:int
@export var node_down_ID:int

@export_file("*.tscn") var levelPath: String

var node_left:Node2D=null
var node_right:Node2D=null
var node_up:Node2D=null
var node_down:Node2D=null

func _ready():
	var mapnodes=get_tree().root.get_node("/root/Root/MapNavNodes")
	mapnodes=mapnodes.get_children()
	
	#connect the mapnodes
	for m in mapnodes:
		if m.ID==node_left_ID:
			node_left = m
		if m.ID==node_right_ID:
			node_right = m
		if m.ID==node_up_ID:
			node_up = m
		if m.ID==node_down_ID:
			node_down = m

#func _process(delta):
#	update()

func drawlines():
	if node_left!=null:
		draw_line(Vector2(0.0,1.0), Vector2(node_left.position.x-self.position.x,node_left.position.y-self.position.y+1.0), Color(255, 0, 0), 1)
	if node_right!=null:
		draw_line(Vector2(0.0,0.0), node_right.position-self.position, Color(0, 255, 0), 1)
	if node_up!=null:
		draw_line(Vector2(1.0,0.0), Vector2(node_up.position.x-self.position.x+1.0,node_up.position.y-self.position.y), Color(0, 0, 255), 1)
	if node_down!=null:
		draw_line(Vector2(0.0,0.0), node_down.position-self.position, Color(0, 255, 255), 1)

func _draw():
	drawlines()
