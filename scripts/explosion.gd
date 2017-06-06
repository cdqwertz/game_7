extends Particles2D

func _ready():
	get_node("SamplePlayer2D").play("explode")
