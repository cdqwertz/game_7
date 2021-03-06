extends Area2D

var velocity = Vector2(0, 0)
var player = null

func _ready():
	connect("body_enter", self, "body_enter")
	set_process(true)
	
func _process(delta):
	set_pos(get_pos() + velocity * delta)
	
func body_enter(body):
	if body != player:
		if body.is_in_group("player"):
			if body.is_in_group("player_1"):
				global.score(2, 1)
			elif body.is_in_group("player_2"):
				global.score(1, 1)
				
			body.kill()
		
		queue_free()
