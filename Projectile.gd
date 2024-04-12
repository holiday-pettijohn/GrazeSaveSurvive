extends Node2D

class_name Projectile

var DMG = 1
var lifetime = 1
var acceleration = Vector2(0, 0)
var velocity = Vector2(0, 0)
var pierces = 0

func _ready():
	lifetime = Globals.MAP_WIDTH / velocity.length() #Roughly the time it takes to leave the map

func _process(delta):
	lifetime -= delta
	if lifetime <= 0:
		queue_free()

func _physics_process(delta):
	velocity.x += acceleration.x*delta
	velocity.y += acceleration.y*delta
	position.x += velocity.x*delta
	position.y += velocity.y*delta

func _on_hitbox_entered(area):
	#Default behavior: Destroy always
	area.get_parent().process_hit(DMG)
	pierces -= 1
	if pierces < 0:
		queue_free()
