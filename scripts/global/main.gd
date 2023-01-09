extends Node


func _ready():
	pass


func _process(_delta):
	if Input.is_action_just_pressed("Join"):
		Network.join_room()
	elif Input.is_action_just_pressed("Launch"):
		Network.create_room()
