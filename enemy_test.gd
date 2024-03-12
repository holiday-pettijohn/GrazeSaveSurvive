extends Enemy

var hp
var velocity
var move_vector

func set_stats():
	MAX_HP = 5
	SPEED = 100
	xp = 1
	
	GROUP = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	set_stats()
	start()

func start():
	$Sprite.play()
	hp = MAX_HP

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move(delta)
	updateAnimation()

func move(delta):
	#Move towards player
	move_vector = get_parent().get_node("Player").position - position
	position += move_vector.normalized() * 0.05
	
func updateAnimation():
	var prevFrame = $Sprite.get_frame()
	var prevFrameProgress = $Sprite.get_frame_progress()
	
	var direction = move_vector.angle()
	$Sprite.animation = "walk_right"
	#Directions are WEIRD. Q1 and Q2 are negative. They go from 0 to PI, right to left.
	if (abs(direction) > 0.5*PI):
		$Sprite.animation = "walk_left"
	if (abs(direction) > 0.4*PI and abs(direction) < 0.6*PI):
		$Sprite.animation = "walk_down"
		if (direction < 0):
			$Sprite.animation = "walk_up"
		
	#Since changing animation resets the frame state, resume old state
	$Sprite.frame = prevFrame
	$Sprite.frame_progress = prevFrameProgress
	
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
