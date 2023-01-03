extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if int(rad_to_deg(get_child(0).rotation)) % 360 > 90 or int(rad_to_deg(get_child(0).rotation)) % 360 > 360 - 90:
		flip_v = true
	else:
		flip_v = false
	get_child(0).rotation += delta
