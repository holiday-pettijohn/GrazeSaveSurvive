extends Entity

signal hit
signal death

var screen_size
var hp

func set_stats():
	#Player Stats (from parent)
	MAX_HP = 1
	SPEED = 300
	DMG_CONTACT = 0
	DMG_RANGED = 5
	
	#Player-specific stats
	var XP = 0
	
	#Assigning values
	hp = MAX_HP

func start(start_position):
	position = start_position
	set_stats();
	$AnimatedSprite2D.animation = "idle"
	$AnimatedSprite2D.play()
	show()

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move(delta)
	
func move(delta):
	#Process player movement
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * SPEED
		$AnimatedSprite2D.animation = "run"
	else:
		$AnimatedSprite2D.animation = "idle"
		
	if velocity.x != 0:
		$AnimatedSprite2D.flip_h = velocity.x < 0
	
	#Update player position
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size) #Player cannot leave screen


func _on_body_entered(body):
	print(body, " entered!")
	hp -= 1
	hit.emit()
	
	#Player death
	if (hp <= 0):
		$AnimatedSprite.animation = "death"
		death.emit()