extends Node2D

onready var game_scene = load("res://scenes/world.tscn")

onready var ai_1 = get_node("settings/ai_1")
onready var ai_2 = get_node("settings/ai_2")

func _ready():
	global.game_state = 2

func _on_play_pressed():
	global.ai_1 = ai_1.is_pressed()
	global.ai_2 = ai_2.is_pressed()
	
	global.game_state = 0
	
	get_tree().change_scene_to(game_scene)
