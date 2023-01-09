extends CharacterBody2D

@onready var Synchronizer: MultiplayerSynchronizer = get_node("Multiplayer/Synchronizer")
@onready var       Sprite:        AnimatedSprite2D = get_node("Sprite")
@onready var       Camera:                Camera2D = get_node("Camera")
@onready var         Wand:                  Node2D = get_node("Wand")

var statistics: Dictionary

var mouse_position: Vector2

var target = null


func _ready():
	set_multiplayer_authority(int(str(name)))
	if is_master():
		Camera.current = true
		mouse_position = get_global_mouse_position()
	statistics = {
		current = {
			hp = 100.,
			mana = 100.,
			energy = 10.,
			speed = 150.
		},
		max = {
			hp = 100.,
			mana = 100.,
			energy = 100.,
			speed = 150.
		}
	}


func _physics_process(delta):
	if is_master():
		mouse_position = get_global_mouse_position()
		get_input()
	move(delta)


func _input(event):
	if is_master():
		if event is InputEventMouseMotion:
			rotation = position.angle_to_point(mouse_position)
			if rotation < -PI/2 or rotation > PI/2:
				Sprite.flip_h = true
				rotation = (rotation - PI * sign(rotation))
			else:
				Sprite.flip_h = false
			rotation /= 5
			Wand.global_rotation = position.angle_to_point(mouse_position)


func get_input():
	velocity = Vector2()
	if Input.is_mouse_button_pressed(2):
		target = mouse_position


func move(delta):
	statistics.current.speed = 150
	if is_master():
		if target != null:
			if position.distance_to(target) > statistics.current.speed * delta:
				velocity += statistics.current.speed * (target - position).normalized()
			else:
				target = null
	else:
			rotation = position.angle_to_point(mouse_position)
			if rotation < -PI/2 or rotation > PI/2:
				Sprite.flip_h = true
				rotation = (rotation - PI * sign(rotation))
			else:
				Sprite.flip_h = false
			rotation /= 5
			Wand.global_rotation = position.angle_to_point(mouse_position)
	move_and_slide()


func is_master():
	return get_multiplayer_authority() == multiplayer.get_unique_id()
