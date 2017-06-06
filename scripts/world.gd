extends Node2D

var timer = 0;

func _ready():
	randomize()
	set_process(true)
	
func _process(delta):
	timer += delta
	
	if timer > 10:
		timer = 0
		
		# add some random events to the game?
		var random_event = randi()%2
