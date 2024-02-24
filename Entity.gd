extends RigidBody2D
class_name Entity #Parent for player and enemies

#Common stats
var MAX_HP : int
var SPEED : int
var DMG_CONTACT : int #Damage induced to others on collision
var DMG_RANGED : int

func set_stats():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
