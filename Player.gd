extends Entity

@export var projectile : PackedScene

signal hit
signal death

var map_size
var screen_size
var alive

var level

var hp
var xp

var xp_mult

var melee_atk
var ranged_atk
var defense

var mCooldownTimer
var rCooldownTimer

# Base melee and ranged cooldowns, in seconds
var MELEE_COOLDOWN = 1
var RANGED_COOLDOWN = 1

var velocity

func set_stats():
	#Player Stats (from parent)
	MAX_HP = 5
	SPEED = 300
	# Base contact and ranged damage
	DMG_CONTACT = 0
	DMG_RANGED = 1

	#Assigning values
	level = 1
	hp = MAX_HP
	xp = 0
	alive = true
	mCooldownTimer = 0
	rCooldownTimer = 0

func start(start_position):
	position = start_position
	velocity = Vector2.ZERO
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
	if (hp <= 0):
		$PlayerSprite.animation = "death"
		death.emit()

func move(delta):
	#Process player movement
	if alive:
		velocity = Vector2.ZERO
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
		ranged_attack()
		print("Player: Ranged attack")
	if Input.is_action_pressed("melee") and mCooldownTimer == 0:
		mCooldownTimer = MELEE_COOLDOWN
		print("Player: Melee attack")

func process_hit(dmg):
	hp -= dmg
	hit.emit()

func ranged_attack():
	var firedBullet = projectile.instantiate()
	var direction = -1 if $PlayerSprite.flip_h else 1
	firedBullet.position = $ProjectileOrigin.global_position
	if direction == -1:
		firedBullet.position.x -= 2*$ProjectileOrigin.position.x
	firedBullet.velocity = Vector2(direction*1000, 0)
	firedBullet.DMG = DMG_RANGED

	add_sibling(firedBullet)


func gain_xp(amount):
	xp += amount
	while xp >= level_threshold(level):
		level_up()

func level_up():
	xp -= level_threshold(level)
	level += 1
	DMG_CONTACT += 1
	DMG_RANGED += 1
	MAX_HP += 2
	print(MAX_HP)
	print(hp)
	print(hp/MAX_HP)

func level_threshold(lvl):
	return lvl*5

func _on_death():
	alive = false

func _on_hit():
	pass # Replace with function body.

func game_over():
	pass # Replace with function body.
