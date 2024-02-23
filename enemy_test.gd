extends Enemy

func set_stats():
	MAX_HP = 100
	SPEED = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	start()

func start():
	$AnimatedSprite2D.animation = "idle"
	$AnimatedSprite2D.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move(delta)
	pass

func move(delta):
	position = position.move_toward(Vector2(570,300), 1) #Move towards the center for now
	pass
