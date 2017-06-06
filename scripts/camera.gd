extends Camera2D

var shake_timer = 0;
var shake_val = 0;

func _ready():
	set_process(true)

func _process(delta):
	if shake_timer > 0:
		shake_timer -= delta
		set_offset(Vector2(rand_range(-shake_val, shake_val), rand_range(-shake_val, shake_val)))
		
func shake(t, v):
	shake_timer = t
	shake_val = v