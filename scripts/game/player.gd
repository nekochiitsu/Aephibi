extends CharacterBody2D

@onready var Synchronizer: MultiplayerSynchronizer = get_node("Multiplayer/Synchronizer")

var max_hp: float = 100
var hp:     float = 100

var max_energy: float = 100
var energy:     float = 100

var max_mana: float = 100
var mana:     float = 100

var speed: float = 2000

var target = null


func _ready():
	# set_multiplayer_authority(int(str(name)))
	if is_master():
		pass # Camera.current = true


func _physics_process(delta):
	if is_master():
		get_input()
	move(delta)


func _input(event):
	if is_master():
		if event is InputEventMouseMotion:
			$Wand.rotation = position.angle_to_point(get_global_mouse_position())
			if $Wand.rotation < -PI/2 or $Wand.rotation > PI/2:	
				$Sprite.flip_h = true
			else:
				$Sprite.flip_h = false


func get_input():
	velocity = Vector2()
	if Input.is_mouse_button_pressed(2):
		target = get_global_mouse_position()


func move(delta):
	speed = 150
	if target != null:
		if position.distance_to(target) > speed * delta:
			velocity += speed * (target - position).normalized()
		else:
			target = null
	move_and_slide()


func is_master():
	return 1 # (get_multiplayer_authority() == multiplayer.get_unique_id())
