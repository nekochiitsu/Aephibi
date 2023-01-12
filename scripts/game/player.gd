extends CharacterBody2D

@onready var         Game:                    Node = get_node("../../..")
@onready var Synchronizer: MultiplayerSynchronizer = get_node("Multiplayer/Synchronizer")
@onready var       Sprite:        AnimatedSprite2D = get_node("Sprite")
@onready var       Camera:                Camera2D = get_node("Camera")
@onready var         Wand:                  Node2D = get_node("Wand")
@onready var        Spell:             PackedScene = load("res://scenes/game/fireball.tscn")

var statistics: Dictionary

var mouse_position: Vector2

var target = null
var cast_buffer: Array = [] 

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
					recoil = 150.,
					recoil_decrease = 0.,
					cd = 0.
				},
				stats = {
					knockback = 5,
					movespeed = 5,

					mana_max = 100,
					energy_max = 50,
					mana_reload_time = 5,
					energy_regen_amount = 5,

					color = Color("red"),
					manacost = 10,
					damage = 8,
					cast_time = 0.2,
					cooldown = 2.,
					recoil = deg_to_rad(1),
					recoil_recovery_time = 5,
					recoil_max = deg_to_rad(60),
					speed = 8,
					damping = 1,
					accuracy = deg_to_rad(10),
					size = 100.,
					range = 100,
					bump = 5
				}
			},
			{
				current = {
					mana = 100.,
					energy = 10.,
					recoil = 150.,
					recoil_decrease = 0.,
					cd = 0.
				},
				stats = {
					knockback = 5,
					movespeed = 5,

					mana_max = 100,
					energy_max = 50,
					mana_reload_time = 5,
					energy_regen_amount = 5,

					color = Color("red"),
					manacost = 10,
					damage = 8,
					cast_time = 0.2,
					cooldown = 0.4,
					recoil = deg_to_rad(1),
					recoil_recovery_time = 5,
					recoil_max = deg_to_rad(60),
					speed = 8,
					damping = 1,
					accuracy = deg_to_rad(10),
					size = 100.,
					range = 100,
					bump = 5
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
		wait_cast()
		stats_trucs(delta)
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
			if (event.keycode == KEY_A or event.keycode == KEY_E) and event.pressed and !event.echo:
				if event.keycode == KEY_A and Game.time >= statistics.wands[0].current.cd:
					can_cast(statistics.wands[0])
				elif Game.time >= statistics.wands[1].current.cd:
					can_cast(statistics.wands[1])
		

func can_cast(spell):
	if spell.current.energy + spell.current.mana >= spell.stats.manacost:
		spell.current.energy -= spell.stats.manacost
		if spell.current.energy < 0:
			spell.current.mana += spell.current.energy
			spell.current.energy = 0
		add_wait_cast(spell)
		print(spell.current)
	else:
		pass


func add_wait_cast(spell):
	spell.current.cd = Game.time + spell.stats.cooldown + spell.stats.cast_time
	cast_buffer.append([spell, Game.time + spell.stats.cast_time])


func wait_cast():
	for e in cast_buffer:
		if Game.time >= e[1]:
			cast(e[0])
			cast_buffer.erase(e)
			pass


func cast(spell):
	spell.current.recoil += spell.stats.recoil
	spell.current.recoil = min(spell.current.recoil, spell.stats.recoil_max)
	bump(spell.stats.knockback)
	var new_spell = Spell.instantiate()
	print(new_spell)
	new_spell.transform = Wand.global_transform
	new_spell.init(spell.stats) #init avec les stats du spell
	get_node("../../Spells").add_child(new_spell, true)
	spell.current.recoil_decrease = spell.current.recoil/spell.stats.recoil_recovery_time


func get_input():
	velocity = Vector2()
	if Input.is_mouse_button_pressed(2):
		target = mouse_position


func bump(value):
	pass

func stats_trucs(delta):
	for e in statistics.wands:
		e.current.energy += e.stats.energy_regen_amount*delta
		if e.current.energy >= e.stats.energy_max:
			e.current.energy = e.stats.energy_max
		e.current.recoil -= e.current.recoil_decrease*delta
		if e.current.recoil < 0:
			e.current.recoil = 0
	

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
