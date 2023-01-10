extends CharacterBody2D

var current_speed: float
var  current_dist: float
var       damping: float

func init(stats):
	modulate = stats.color
	scale = stats.size/100
	current_speed = stats.speed
	current_dist = stats.range
	rotation += (randf()-0.5)*2*stats.accuracy #entre -1 et 1


func _ready():
	pass


func _process(delta):
	velocity = current_speed*delta*rotation
	move_and_slide()
	current_dist -= current_speed
	if current_dist < 0:
		queue_free()
	current_speed -= damping*delta
