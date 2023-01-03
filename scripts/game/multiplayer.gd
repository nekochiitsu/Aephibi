extends Node

var Player: CharacterBody2D

var Online: Dictionary = {
	position = Vector3(),
	rotation = Vector3(),
	velocity = Vector3(),
	weapon_rotation = Vector3()
}


func _ready():
	Player = get_parent()
	Online.position        = Player.position
	Online.rotation        = Player.rotation
	Online.velocity        = Player.velocity
	Online.hp              = Player.hp
	Online.weapon_rotation = Player.get_node("Weapon").rotation


func _process(delta):
	if !Player.is_master():
		Player.position        = Online.position
		Player.rotation        = Online.rotation
		Player.velocity        = Online.velocity
		Player.Weapon.rotation = Online.Camera_rotation
	else:
		Online.position        = Player.position
		Online.rotation        = Player.rotation
		Online.velocity        = Player.velocity
		Online.weapon_rotation = Player.Weapon.rotation
