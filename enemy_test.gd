extends Enemy

@export var xp_scene : PackedScene
var hp
var velocity

func set_stats():
	MAX_HP = 5
	SPEED = 100
	xp = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	start()

func start():
	$AnimatedSprite2D.animation = "walk_right" #Default
	$AnimatedSprite2D.play()
	hp = MAX_HP

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move(delta)
	updateAnimation()

func move(delta):
	position = position.move_toward(Vector2(570,300), 1) #Move towards the center for now
	
func updateAnimation():
	pass
	
func _on_body_entered(body):
	hp -= 1
	
	if (hp <= 0):
		#Drop XP on death - Move to main function
		var i = xp
		while (i > 0):
			var newXpOrb = xp_scene.instantiate()
			newXpOrb.position = self.position
			#addchild(newXpOrb) - Must move this to the main function!
			i -= 1
