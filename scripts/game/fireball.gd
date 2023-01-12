extends CharacterBody2D

var current_speed: float
var  current_dist: float
var       damping: float

func init(stats):
	modulate = stats.color
	scale *= stats.size/100
	current_speed = stats.speed
	current_dist = stats.range
	rotation += (randf()-0.5)*2*stats.accuracy #entre -1 et 1


func _ready():
	pass

func _process(delta):
	velocity = transform.x * current_speed
	move_and_slide()
	current_dist -= current_speed * delta
	current_speed -= damping*delta
	if current_dist < 0 or current_speed < 0:
		queue_free()
