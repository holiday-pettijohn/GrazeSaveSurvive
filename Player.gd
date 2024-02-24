extends Entity

signal hit
signal death

var screen_size
var hp

var alive

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
	alive = true

func start(start_position):
	position = start_position
	set_stats();
	$PlayerSprite.animation = "idle"
	$PlayerSprite.play()
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
	if alive:
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
			$PlayerSprite.animation = "run"
		else:
			$PlayerSprite.animation = "idle"
		
		if velocity.x != 0:
			$PlayerSprite.flip_h = velocity.x < 0
		
		#Update player position
		position += velocity * delta
		position = position.clamp(Vector2.ZERO, screen_size) #Player cannot leave screen


func _on_hurt_area_entered(area):
	print(area, " entered!")
	print(area.get_parent().GROUP)
	print(hp)
	if area.get_parent().GROUP == 2:
		hp -= 1
		hit.emit()
	
	#Player death
	if (hp <= 0):
		$PlayerSprite.animation = "death"
		death.emit()

func _on_death():
	alive = false

func _on_hit():
	pass # Replace with function body.

