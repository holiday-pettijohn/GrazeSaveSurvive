extends Enemy

var hp
var velocity
var move_left #TEMP FOR MOVEMENT TESTING

func set_stats():
	MAX_HP = 5
	SPEED = 100
	xp = 1
	
	GROUP = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	set_stats()
	
	move_left = false
	$Sprite.animation = "walk_right"
	if (self.position.x > 0):
		move_left = true
		$Sprite.animation = "walk_left"
	start()

func start():
	$Sprite.play()
	hp = MAX_HP

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move(delta)
	#updateAnimation()

func move(delta):
	#Move towards player
	var move_vector = get_parent().get_node("Player").position - position
	position += move_vector.normalized() * 0.05
	
	#if (move_left == false):
		#position.x += 100 * delta
	#else:
		#position.x -= 100 * delta
	
func updateAnimation():
	pass
	#if velocity.x > 0:
		#$AnimatedSprite2D.animation = "walk_right"
	#elif velocity.x < 0:
		#$AnimatedSprite2D.animation = "walk_left"
	#else:
		#$AnimatedSprite2D.animation = "idle"
		#
	#if velocity.x != 0:
		#$AnimatedSprite2D.flip_h = velocity.x < 0
	#if (velocity == Vector2.ZERO):
		#$AnimatedSprite2D.stop()
		#$AnimatedSprite2D.set_index
	
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
