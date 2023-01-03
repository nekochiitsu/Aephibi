extends Node

#--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---#
#--- Global Network script   --- --- --- --- --- --- --- --- --- --- --- ---#
#--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---#

# multiplayer.get_remote_sender_id() dans un RPC donne l'id de celui qui a call la fonction

var TARGET_IP: String = "127.0.0.1" # Server IP adress used to connect client to the sever
var PORT: int = 2121 # Connection port used for the network connection

var ENet: ENetMultiplayerPeer # Multiplayer tool
var players = [] # Contain all connected players


func create_room():
	# Crée un serveur 
	print("Trying to create a server: ")

	ENet = ENetMultiplayerPeer.new() # Create multiplayer instance
	ENet.create_server(PORT) # Create an server
	multiplayer.multiplayer_peer = ENet # Set multiplayer instance for godot networking processes

	connect_peer(1) # Add the "Server" player (ID 1) to the list of players

	multiplayer.peer_connected.connect(self.connect_peer) # When an peer connect to this server it 
	# will execute the connect_peer function
	multiplayer.peer_disconnected.connect(self.disconnect_peer) # Same with the disconnect_peer func

	print("\tServer created ?:\t", ENet.get_connection_status())


func join_room():
	# Create an client and connect him to the server
	print("Trying to connect to the server: ")

	ENet = ENetMultiplayerPeer.new() # Create multiplayer instance
	ENet.create_client(TARGET_IP, PORT) # Create an client by connecting him to the server
	# This will call the connect_peer function on the server (see l.22)
	multiplayer.multiplayer_peer = ENet # Set multiplayer instance for godot networking processes

	print("\tPeer connected ?:\t", ENet.get_connection_status())
	print("Ending of the connection phase. \n")

#--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---#
#--- --- Game Network script --- --- --- --- --- --- --- --- --- --- --- ---#
#--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---#

@onready var Player: Object = preload("res://scripts/game/player.tscn")


func connect_peer(id: int):
	players.append(id)
	instanciate_player(id)
	print("Client connection:\t", id)


func disconnect_peer(id: int):
	players.erase(id)
	uninstanciate_player(id)
	print("Client disconnection:\t", id)


func instanciate_player(id: int):
	print(id)
	var player = Player.instantiate()
	player.name = str(id)
	get_node("/root/Game/Entities/Players/").add_child(player)


func uninstanciate_player(id: int):
	get_node("/root/Game/Entities/Players/" + str(id)).queue_free()


func _process(delta):
	if Input.is_action_just_pressed("Join"):
		join_room()
	elif Input.is_action_just_pressed("Launch"):
		create_room()








