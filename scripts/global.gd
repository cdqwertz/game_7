extends Node

var score_1 = 0
var score_2 = 0

var max_score = 10

func _ready():
	print("raedy")
	
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
	if player == 1:
		print("cyan won")
	elif player == 2:
		print("pink won")
	else:
		print("[error] unknown player")
	
	