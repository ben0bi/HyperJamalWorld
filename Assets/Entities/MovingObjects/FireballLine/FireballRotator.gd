extends Area2D

@export var speed=45
@export var ballRotationSpeed=-300

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.rotation_degrees+=speed*delta
	for ball in $Ballsprites.get_children():
		ball.rotation_degrees+=ballRotationSpeed*delta
	
# a body entered the area
func _on_body_entered(body):
	if body.is_in_group("Player"):
		body.hit()
