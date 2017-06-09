extends Node2D

export var enable = false
export var player_path = "world/player_1"
export var enemy_path = "world/player_2"
onready var player = get_tree().get_root().get_node(player_path)
onready var enemy = get_tree().get_root().get_node(enemy_path)

var timer = 0
var speed = 0.3

func _ready():
	set_process(true)
	randomize()
	
	speed += randf()*0.2 - 0.1

func _process(delta):
	timer += delta

	if timer > speed and global.game_state == 0 and get_tree().get_nodes_in_group("player").size() > 0 and enable:
		timer = 0

		var pos = player.get_pos()
		var space = get_world_2d().get_direct_space_state()

		print(pos)
		var ray_1 = space.intersect_ray(pos, pos + Vector2(320, 0), [self, player])
		if not(ray_1.empty()):
			if ray_1.collider.is_in_group("player"):
				player.set_linear_velocity(player.right(player.get_linear_velocity()))
				return

		var ray_2 = space.intersect_ray(pos, pos + Vector2(-320, 0), [self, player])
		if not(ray_2.empty()):
			if ray_2.collider.is_in_group("player"):
				player.set_linear_velocity(player.left(player.get_linear_velocity()))
				return

		var dy = pos.y - enemy.get_pos().y

		if player.jump < 1:
			if dy > 0:
				if player.gravity_dir != -1:
					player.set_linear_velocity(player.set_gravity(-1, player.get_linear_velocity()))
			else:
				if player.gravity_dir != 1:
					player.set_linear_velocity(player.set_gravity(1, player.get_linear_velocity()))
		else:
			if dy > 0:
				if player.gravity_dir != 1:
					player.set_linear_velocity(player.set_gravity(1, player.get_linear_velocity()))

				if randf() >= 0.5:
					player.set_linear_velocity(player.right(player.get_linear_velocity()))
				else:
					player.set_linear_velocity(player.left(player.get_linear_velocity()))
			else:
				if player.gravity_dir != -1:
					player.set_linear_velocity(player.set_gravity(-1, player.get_linear_velocity()))

				if randf() >= 0.5:
					player.set_linear_velocity(player.right(player.get_linear_velocity()))
				else:
					player.set_linear_velocity(player.left(player.get_linear_velocity()))

		#player.set_linear_velocity(player.invert_gravity(player.get_linear_velocity()))
