extends Node2D

class_name Projectile

var DMG = 1
var acceleration = Vector2(0, 0)
var velocity = Vector2(0, 0)
var pierces = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not (0 <= position.x and position.x <= 800) or not (0 <= position.y and position.y <= 800):
		queue_free()

func _physics_process(delta):
	velocity.x += acceleration.x*delta
	velocity.y += acceleration.y*delta
	position.x += velocity.x*delta
	position.y += velocity.y*delta

func _on_body_entered(body):
	body.get_parent().process_hit(DMG)
	pierces -= 1
	if pierces < 0:
		queue_free()
