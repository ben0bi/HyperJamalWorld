extends Node2D

@onready var player = get_tree().root.get_node("/root/Root/Player")
@onready var mapnodes=get_tree().root.get_node("/root/Root/MapNavNodes")
@onready var menu=get_tree().root.get_node("/root/Root/Menu")

@export var playerspeed=65
var next_map_node = null # the next map node to go to.
var coming_from = 0 # 1 from left, 2 from right, 3 from up, 4 from down

# Called when the node enters the scene tree for the first time.
func _ready():
	player.setAnimation("down_idle")
	if PlayerData.is_big:
		player.grow()
	# get the children (map nav nodes) from the mapnavnodes node.
	# then set the player position.
	mapnodes=mapnodes.get_children()
	var m=getmapnodebyid(PlayerData.map_pos_id)	
	if m!=null:
		player.position=m.position
		PlayerData.actual_map_node = m

# get a map node from the mapnodes array
# mapnodes must be get_children() of MapNavNodes.
func getmapnodebyid(id):
	for m in mapnodes:
		if m.ID==id:
			return m

# Called every frame. 'delta' is the elapsed time since the previous frame.
# we get the map input here and move the player sprite
func _process(delta):
	var m=PlayerData.actual_map_node
	var moved=false
	# only get input if mapnode is not null.
	if m!=null:
		if Input.is_action_just_pressed("ui_accept"):
			if m.levelPath!="":
				get_tree().change_scene_to_file(m.levelPath)
		if Input.is_action_just_pressed("ui_right"):
			if m.node_right!=null:
				if m.node_right.stars_needed<=PlayerData.actual_stars:
					player.setAnimation("right_walk")
					next_map_node=m.node_right
					coming_from = 1
					moved=true
				else:
					menu.showMoreStarsNeeded(m.node_right.stars_needed-PlayerData.actual_stars)
		if Input.is_action_just_pressed("ui_left"):
			if m.node_left!=null:
				if m.node_left.stars_needed<=PlayerData.actual_stars:
					player.setAnimation("left_walk")
					next_map_node=m.node_left
					coming_from = 2
					moved=true
				else:
					menu.showMoreStarsNeeded(m.node_left.stars_needed-PlayerData.actual_stars)
		if Input.is_action_just_pressed("ui_up"):
			if m.node_up!=null:
				if m.node_up.stars_needed<=PlayerData.actual_stars:
					player.setAnimation("up_walk")
					next_map_node=m.node_up
					coming_from = 4
					moved=true
				else:
					menu.showMoreStarsNeeded(m.node_up.stars_needed-PlayerData.actual_stars)
		if Input.is_action_just_pressed("ui_down"):
			if m.node_down!=null:
				if m.node_down.stars_needed<=PlayerData.actual_stars:
					player.setAnimation("down_walk")
					next_map_node=m.node_down
					coming_from = 3
					moved=true
				else:
					menu.showMoreStarsNeeded(m.node_down.stars_needed-PlayerData.actual_stars)

	if moved==true:
		PlayerData.actual_map_node = null
		#player.position=PlayerData.actual_map_node.position

	if next_map_node!=null:
		# move the player
		if player.position!=next_map_node.position:
			var dir = next_map_node.position-player.position
			dir = dir.normalized()
			player.position+= dir*playerspeed*delta
			
			if abs(next_map_node.position.x-player.position.x)<playerspeed*delta:
				player.position.x=next_map_node.position.x
			if abs(next_map_node.position.y-player.position.y)<playerspeed*delta:
				player.position.y=next_map_node.position.y
		else:
			# select next map node
			if next_map_node.stop==true:
				set_new_player_position()
			else:
				select_next_unstopped_map_node()
	pass

# set the player position after movement was done
func set_new_player_position():
	PlayerData.actual_map_node=next_map_node
	PlayerData.map_pos_id=PlayerData.actual_map_node.ID
	player.setAnimation("down_idle")
	next_map_node = null

# select the next map node which is not the one where we are coming from
func select_next_unstopped_map_node():
	var act=next_map_node
	var next = null
	if act!=null:
		if coming_from!=1 and act.node_left!=null:
			next=act.node_left
			player.setAnimation("left_walk")
		if coming_from!=2 and act.node_right!=null:
			next=act.node_right
			player.setAnimation("right_walk")
		if coming_from!=3 and act.node_up!=null:
			next=act.node_up
			player.setAnimation("up_walk")
		if coming_from!=4 and act.node_down!=null:
			next=act.node_down
			player.setAnimation("down_walk")
		
		if next!=null:
			next_map_node = next
		else:
			set_new_player_position()
	pass
