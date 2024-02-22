extends Area2D
@export var speed = 400
var screen_size

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	$AnimatedSprite2D.animation = "idle"
	$AnimatedSprite2D.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.animation = "run"
	else:
		$AnimatedSprite2D.animation = "idle"
		
	if velocity.x != 0:
		$AnimatedSprite2D.flip_h = velocity.x < 0
	
	#Update player position
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size) #Player cannot leave screen
	pass
