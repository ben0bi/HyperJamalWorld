extends Node

var actual_lifes = 5

# player is active and not dead
var is_active = true

# player has one more "life" if big.
var is_big = false

# the id of the actual map node.
# actual map node will be set with id.
var map_pos_id = 1
var actual_map_node=null

# stars the player has collected till now.
var actual_stars=1
# dictionary which determines if a star in a level is already collected.
# stars reference to their map position id.
# there is only one star in the level.
var collected_stars = {}

# the coins the player has.
var actual_coins = 0

# add a coin
func addCoin():
	actual_coins+=1
	if actual_coins>=100:
		actual_coins=0
		actual_lifes+=1

# add a star if not and put it in the already collected list.
func addStar():
	if starAlreadyCollected() == false:
		actual_stars+=1
		collected_stars[map_pos_id]=true

# check if the star on map_pos_id is already collected.
func starAlreadyCollected():
	if not collected_stars.has(map_pos_id):
		return false
	else:
		return collected_stars[map_pos_id]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

