extends Entity #Inherit from Entity class
class_name Enemy

@export var xp_scene : PackedScene

@export var xp = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	GROUP = 2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func move_towards_player():
	pass
	
func _on_death():
	var xpOrb = xp_scene.instantiate()
	var spawnPosition = Vector2.ZERO
	xpOrb.position = self.position
	
	add_child(xpOrb)
	

