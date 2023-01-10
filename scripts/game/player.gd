extends CharacterBody2D

@onready var Synchronizer: MultiplayerSynchronizer = get_node("Multiplayer/Synchronizer")
@onready var       Sprite:        AnimatedSprite2D = get_node("Sprite")
@onready var       Camera:                Camera2D = get_node("Camera")
@onready var         Wand:                  Node2D = get_node("Wand")
@onready var        Spell:             PackedScene = load("res://scenes/game/fireball.tscn")

var statistics: Dictionary

var mouse_position: Vector2

var target = null


func _ready():
	set_multiplayer_authority(int(str(name)))
	if is_master():
		Camera.current = true
		mouse_position = get_global_mouse_position()
	statistics = {
		wands = [
			{
				current = {
					mana = 100.,
					energy = 10.,
					recoil = 150.
				},
				stats = {
					mana = 100.,
					energy = 100.,
					recoil = 150.
				}
			},
			{
				current = {
					mana = 100.,
					energy = 10.,
					recoil = 150.
				},
				stats = {
					mana = 100.,
					energy = 100.,
					recoil = 150.
				}
			}
		],
		hp = 100.,
		hp_max = 60,
		base_speed = 150.

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
		if event is InputEventKey:
			if event.keycode == KEY_A: #à mettre en input
				if !event.echo: #check le hold
					var new_spell = Spell.instantiate()
					new_spell.transform = Wand.global_transform
					#new_spell.init(stats) init avec les stats de la wand
					get_node("../../Spells").add_child(new_spell)



func get_input():
	velocity = Vector2()
	if Input.is_mouse_button_pressed(2):
		target = mouse_position


func move(delta):
	statistics.speed = 150
	if is_master():
		if target != null:
			if position.distance_to(target) > statistics.speed * delta:
				velocity += statistics.speed * (target - position).normalized()
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
