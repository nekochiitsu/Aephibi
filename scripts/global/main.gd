extends Node

var time: float = 0.

func _ready():
	pass


func _process(delta):
	time += delta
	if Input.is_action_just_pressed("Join"):
		Network.join_room()
	elif Input.is_action_just_pressed("Launch"):
		Network.create_room()
