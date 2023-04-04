extends Area2D

var alreadyCollected=false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Collected.visible=false
	if PlayerData.starAlreadyCollected():
		alreadyCollected = true
		$Star.visible=false
		$Collected.visible = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# player collects this star
func _on_body_entered(body):	
	if body.is_in_group("Player"):
		PlayerData.addStar() # add the star if not already collected
		Globals.changeToMap()
	pass # Replace with function body.
