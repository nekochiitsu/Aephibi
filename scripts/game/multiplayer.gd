extends Node

@onready var Player: CharacterBody2D = get_parent()

var Online: Dictionary


func _ready():
	Online = {
	position       = Player.position,
	velocity       = Player.velocity,
	mouse_position = Vector2()
	}


func _process(_delta):
	if Player.is_master():
		Online.position       = Player.position
		Online.mouse_position = Player.mouse_position
		Online.velocity       = Player.velocity
	else:
		Player.position       = Online.position
		Player.mouse_position = Online.mouse_position
		Player.velocity       = Online.velocity
