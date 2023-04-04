extends Area2D

signal on_layer
signal off_layer

var onSpike:bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_entered(body):
	if onSpike==false:
		var overlapping_bodies=get_overlapping_bodies()
		if overlapping_bodies.size()>=1:
			emit_signal("on_layer")

func _on_body_exited(body):
	var overlapping_bodies=get_overlapping_bodies()
	if overlapping_bodies.size()==0:
		onSpike=false
		emit_signal("off_layer")
