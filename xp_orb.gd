extends Area2D

var amount = 1
var direction
var SPEED
var friction

# Called when the node enters the scene tree for the first time.
func _ready():
	#Pick a random direction to move
	direction = randf_range(-PI, PI)
	SPEED = randi_range(100, 200)
	friction = 2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#Move in a random direction (for visual effect)
	position += Vector2(1.0,0.0).rotated(direction) * SPEED * delta
	SPEED = max(0, SPEED - friction)

func _on_area_entered(area):
	area.get_parent().gain_xp(amount)
	queue_free() #Get consumed
