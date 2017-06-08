extends Node2D

var timer = 0;

export var win_cyan_path = "res://objects/win_cyan.tscn"
export var win_pink_path = "res://objects/win_pink.tscn"

onready var win_cyan = load(win_cyan_path)
onready var win_pink = load(win_pink_path)

func _ready():
	randomize()
	set_process(true)
	set_process_unhandled_input(true)

func _process(delta):
	timer += delta

	if timer > 10:
		timer = 0
		var random_powerup = randi()%3

		for pl in get_tree().get_nodes_in_group("player"):
			pl.power_up = random_powerup

		print("randomize ", random_powerup)

		if random_powerup > 0:
			get_node("camera").shake(0.1, 3)

func win(player):
	for i in get_tree().get_nodes_in_group("player"):
		i.kill()
		i.queue_free()

	for i in get_tree().get_nodes_in_group("block"):
		i.queue_free()

	if player == 1:
		var obj = win_cyan.instance()
		obj.set_pos(Vector2(320/2, 320/2))
		add_child(obj)
	else:
		var obj = win_pink.instance()
		obj.set_pos(Vector2(320/2, 320/2))
		add_child(obj)
		
func _unhandled_input(event):
	if event.is_action_pressed("ui_accept") and global.game_state == 1:
		global.game_state = 0
		global.score_1 = 0
		global.score_2 = 0

		get_tree().reload_current_scene()
