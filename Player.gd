extends Entity

signal hit
signal death

var map_size
var screen_size

var hp
var alive
var XP
var MELEE_COOLDOWN = 1 #Seconds
var RANGED_COOLDOWN = 1
var mCooldownTimer
var rCooldownTimer

func set_stats():
	#Player Stats (from parent)
	MAX_HP = 1
	SPEED = 300
	DMG_CONTACT = 0
	DMG_RANGED = 5

	#Player-specific stats
	XP = 0

	#Assigning values
	hp = MAX_HP
	alive = true
	mCooldownTimer = 0
	rCooldownTimer = 0

func start(start_position):
	position = start_position
	set_stats();
	$PlayerSprite.animation = "idle"
	$PlayerSprite.play()
	$Camera2D.reset_smoothing() #Camera jumps immediately to the player

func _ready():
	#Set camera bounds
	$Camera2D.limit_top = 0
	$Camera2D.limit_left = 0
	$Camera2D.limit_right = Globals.MAP_WIDTH
	$Camera2D.limit_bottom = Globals.MAP_HEIGHT

func _process(delta):
	move(delta)
	process_actions(delta)

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
		position = position.clamp(Vector2.ZERO, Globals.MAP_SIZE) #Player cannot leave screen

func process_actions(delta):
	rCooldownTimer = max(rCooldownTimer - delta, 0)
	mCooldownTimer = max(mCooldownTimer - delta, 0)

	if Input.is_action_pressed("ranged") and rCooldownTimer == 0:
		rCooldownTimer = RANGED_COOLDOWN
		print("Player: Ranged attack")
	if Input.is_action_pressed("melee") and mCooldownTimer == 0:
		mCooldownTimer = MELEE_COOLDOWN
		print("Player: Melee attack")

func _on_hurt_area_entered(area):
	print(area, " entered!")
	print(area.get_parent().GROUP)
	print(hp)
	if area.get_parent().GROUP == 2:
		hp -= 1
		hit.emit()

func _on_death():
	alive = false

func _on_hit():
	pass # Replace with function body.

