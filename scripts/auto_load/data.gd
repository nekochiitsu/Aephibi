extends Node

var wands: Dictionary

# Called when the node enters the scene tree for the first time.
func _ready():
	wands = {
knockback = 5,
movespeed = 5,

mana_max = 100,
fmana_max = 50,
mana_reload_time = 5,
fmana_regen_amount = 5,

color = Color("red"),
manacost = 10,
damage = 8,
cast_time = 0.2,
cooldown = 0.4,
recoil = 1,
recoil_recovery_time = 5,
recoil_max = 60,
speed = 8,
damping = 1,
accuracy = 10,
size = 100,
range = 100,
bump = 5
} 



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
