extends RigidBody2D

export var shot_path = "res://objects/shot_1.tscn"
export var explosion_path = "res://objects/explosion_1.tscn"

onready var my_sprite = get_node("sprite")
onready var my_shot = load(shot_path)
onready var my_explosion = load(explosion_path)

onready var sample_jump = get_node("sample_jump")

var gravity_dir = 1

export var action_left = "ui_left"
export var action_right = "ui_right"
export var action_invert_gravity = "ui_up"

var jump = 3
var power_up = 0

func _ready():
	set_process(true)
	set_process_unhandled_input(true)
	
	set_contact_monitor(true)
	set_max_contacts_reported(true)
	
func _process(delta):
	var velocity = get_linear_velocity()
	velocity.y += 200*delta*gravity_dir;
	
	var bodies = get_colliding_bodies()
	if bodies.size() > 0:
		jump = 3
		
		for body in bodies:
			if body.is_in_group("top"):
				if gravity_dir != -1 and velocity.y < 0:
					set_gravity(-1, velocity)
			elif body.is_in_group("bottom"):
				if gravity_dir != 1 and velocity.y > 0:
					set_gravity(1, velocity)
	
	set_linear_velocity(velocity)
	
	if get_pos().x < 0 or get_pos().y < 0 or get_pos().x > 320 or get_pos().y > 320:
		kill()
	
func _unhandled_input(event):
	var velocity = get_linear_velocity()
	
	if event.is_action_pressed(action_left) and jump > 0:
		velocity = left(velocity)
	elif event.is_action_pressed(action_right) and jump > 0:
		velocity = right(velocity)
	elif event.is_action_released(action_left) or event.is_action_released(action_right):
		if gravity_dir == 1:
			my_sprite.set_frame(0)
		else:
			my_sprite.set_frame(3)
	elif event.is_action_pressed(action_invert_gravity):
		velocity = invert_gravity(velocity)
		
	set_linear_velocity(velocity)


func left(velocity):
	if not(jump > 0):
		return velocity
		 
	velocity.x = -100;
	velocity.y = -150*gravity_dir;
	
	if gravity_dir == 1:
		my_sprite.set_frame(1)
	else:
		my_sprite.set_frame(4)
	
	shoot(velocity)
	sample_jump.play("jump")
	
	jump -= 1
	return velocity

func right(velocity):
	if not(jump > 0):
		return velocity
		
	velocity.x = 100;
	velocity.y = -150*gravity_dir

	if gravity_dir == 1:
		my_sprite.set_frame(2)
	else:
		my_sprite.set_frame(5)
	
	shoot(velocity)
	sample_jump.play("jump")
	
	jump -= 1
	return velocity
	
func invert_gravity(velocity):
	return set_gravity(gravity_dir * (-1), velocity)
	
func set_gravity(dir, velocity):
	gravity_dir = dir
	velocity.y = 5*gravity_dir;
	
	if gravity_dir == 1:
		my_sprite.set_frame(0)
	else:
		my_sprite.set_frame(3)
		
	return velocity

func shoot(velocity):
	if power_up == 1:
		shoot_2(Vector2((velocity.x/4*3), velocity.y), 0)
		shoot_2(Vector2(-(velocity.x/4*3), velocity.y), 0)
	elif power_up == 2:
		shoot_2(Vector2(velocity.x/2, velocity.y), 8)
		shoot_2(Vector2(velocity.x/5*3 , velocity.y), 0)
		shoot_2(Vector2(velocity.x/2, velocity.y), -8)
	else:
		shoot_2(velocity, 0)

func shoot_2(velocity, y):
	var shot = my_shot.instance()
	shot.set_pos(get_pos()+Vector2(velocity.x/10.0, y))
	shot.velocity = Vector2(velocity.x*4, 0)
	shot.player = self
	get_parent().add_child(shot)
	return shot

func kill():
	var e = my_explosion.instance()
	e.set_pos(get_pos())
	get_parent().add_child(e)
	e.set_emitting(true)
	
	get_parent().get_node("camera").shake(0.1, 3)
	global.kill()
	
	respawn()
	
func respawn():
	set_linear_velocity(Vector2(0, 0))
	var my_nodes = get_tree().get_nodes_in_group("spawn")
	var i = 0
	var best = 0
	var best_dist = 0
	while i < my_nodes.size():
		var dist = get_pos().distance_to(my_nodes[i].get_pos())
		
		if dist > best_dist:
			best = i
			best_dist = dist
		
		i += 1
	
	set_pos(my_nodes[best].get_pos())
