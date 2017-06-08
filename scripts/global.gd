extends Node

var score_1 = 0
var score_2 = 0

var max_score = 10

var game_state = 0

var ai = true

func _ready():
	pass

func score(player, n):
	if player == 1:
		score_1 += n
	elif player == 2:
		score_2 += n
	else:
		print("[error] unknown player")

	if score_1 >= max_score:
		win(1)
	elif score_2 >= max_score:
		win(2)

func win(player):
	game_state = 1

	if player == 1:
		print("cyan won ", score_1, " ", score_2)
		get_tree().get_root().get_node("world").win(1)
	elif player == 2:
		print("pink won ", score_1, " ", score_2)
		get_tree().get_root().get_node("world").win(2)
	else:
		print("[error] unknown player")

func kill():
	pass
