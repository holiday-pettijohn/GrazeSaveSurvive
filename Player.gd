extends Entity

@export var projectile : PackedScene

signal hit
signal death

var map_size
var screen_size
var alive
var contacting = {} #Keep track of enemies contacting player

var level

var hp
var xp

var xp_mult

var MELEE_RANGE
var DMG_MELEE
var defense

var mCooldownTimer
var rCooldownTimer
var hurtCooldownTimer

# Base melee and ranged cooldowns, in seconds
var MELEE_COOLDOWN = 1
var RANGED_COOLDOWN = 1
var HURT_COOLDOWN = 1

var velocity

const upgrades = preload("res://upgrades_grid.gd")

@onready var hitSound = $"Hit SFX"
@onready var pickupSFX = $"Pickup SFX"
@onready var hurtSFX = $"HurtSound"

func set_stats():
	alive = true

	#Player Stats (from parent)
	MAX_HP = 5 + (0.5 * upgrades.tile_upgrades[7])
	SPEED = 250
	# Base contact and ranged damage
	DMG_CONTACT = 0
	DMG_RANGED = 1 + (0.05 * upgrades.tile_upgrades[0]) + (0.05 * upgrades.tile_upgrades[2])

	#Assigning values
	level = 1
	hp = MAX_HP
	xp = 0

	#Attack Stats
	mCooldownTimer = 0
	MELEE_RANGE = 64 + (2 * upgrades.tile_upgrades[3])#Melee collision box x-offset from player
	DMG_MELEE = 1 + (0.05 * upgrades.tile_upgrades[1]) + (0.05 * upgrades.tile_upgrades[2])
	rCooldownTimer = 0
	hurtCooldownTimer = 0
	
	RANGED_COOLDOWN -= (0.1 * upgrades.tile_upgrades[5])
	MELEE_COOLDOWN -= (0.1 * upgrades.tile_upgrades[6])

func start(start_position):
	position = start_position
	velocity = Vector2.ZERO
	upgrades.get_tile_buffs()
	set_stats();
	$PlayerSprite.animation = "idle"
	$PlayerSprite.play()
	$Camera2D.reset_smoothing() #Camera jumps immediately to the player
	show()

	#Attacks
	melee_hide() #Hide collision box

func _ready():
	hide()
	
	#Set camera bounds
	$Camera2D.limit_top = 0
	$Camera2D.limit_left = 0
	$Camera2D.limit_right = Globals.MAP_WIDTH
	$Camera2D.limit_bottom = Globals.MAP_HEIGHT

func _process(delta):
	if (!alive):
		return

	move(delta)
	process_actions(delta)
	process_dmg(delta)

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
	if Input.is_action_pressed("melee") and mCooldownTimer == 0:
		mCooldownTimer = MELEE_COOLDOWN
		melee_attack()

func process_dmg(delta):
	hurtCooldownTimer = max(hurtCooldownTimer - delta, 0)
	
	if hurtCooldownTimer > 0:
		$PlayerSprite.modulate = Color(1,1,1,0.5)
		return
	else:
		$PlayerSprite.modulate = Color(1,1,1,1)
	
	#If enemies are contacting player, take continuous damage
	if (contacting.size() > 0):
		var dmg_highest = 0
		#Get highest damage out of all enemies contacting player
		for enemy in contacting:
			if contacting[enemy] > dmg_highest:
				dmg_highest = contacting[enemy]
		process_hit(dmg_highest)

func process_hit(dmg):
	if (hurtCooldownTimer > 0):
		return
	
	hurtCooldownTimer = HURT_COOLDOWN
	
	if (hp > 0):
		hurtSFX.play() #Check health
		
	hp -= dmg #Apply dmg
	
	if (hp <= 0):
		death.emit() #Check death
	
	hit.emit()

func ranged_attack():
	var firedBullet = projectile.instantiate()
	var direction = -1 if $PlayerSprite.flip_h else 1
	firedBullet.position = $ProjectileOrigin.global_position
	if direction == -1:
		firedBullet.position.x -= 2*$ProjectileOrigin.position.x
	firedBullet.velocity = Vector2(direction*(1000 + (10 * upgrades.tile_upgrades[4])), 0)
	firedBullet.DMG = DMG_RANGED

	hitSound.play()
	add_sibling(firedBullet)

############## MELEE ATTACK FUNCTIONS ##############
func melee_attack():
	$MeleeBody.show()
	$MeleeBody/MeleeBox.set_deferred("disabled", false)
	$MeleeBody.position.x = MELEE_RANGE * (-1 ** int($PlayerSprite.flip_h))
	$MeleeBody/MeleeSprite.flip_h = $PlayerSprite.flip_h

	#Set timer for melee duration
	$MeleeBody/MeleeDuration.one_shot = true
	$MeleeBody/MeleeDuration.wait_time = 0.2 #Time an attack stays on screen
	$MeleeBody/MeleeDuration.start()

	hitSound.play()

func melee_hide():
	$MeleeBody.hide()
	$MeleeBody/MeleeBox.set_deferred("disabled", true)
	$MeleeBody.position.x = 0 #Reset to player position

func _on_melee_duration_timeout():
	melee_hide()

######################################################

func gain_xp(amount):
	xp += amount
	while xp >= level_threshold(level):
		level_up()

func level_up():
	xp -= level_threshold(level)
	level += 1
	DMG_MELEE += 1
	DMG_RANGED += 1
	MAX_HP += 2
	hp = MAX_HP #Fully heal upon level-up
	MELEE_COOLDOWN *= 0.9
	RANGED_COOLDOWN *= 0.9
	print(MAX_HP)
	print(hp)
	print(hp/MAX_HP)
	pickupSFX.play()

func level_threshold(lvl):
	return lvl*10

func _on_death():
	alive = false
	$PlayerSprite.animation = "death"
	$PickupBody/PickupBox.set_deferred("disabled", true) #Disable pickups
	$Body/Hurtbox.set_deferred("disabled", true)
	db.refresh()

func _on_hit():
	pass # Replace with function body.

func game_over():
	pass # Replace with function body.


func _on_melee_body_area_entered(body):
	body.get_parent().process_hit(DMG_MELEE)

func enemy_enter(enemy):
	contacting[enemy.get_instance_id()] = enemy.DMG_CONTACT #Track enemy id and damage
	#print("Enemy entered: ", contacting)

func enemy_exit(enemy):
	contacting.erase(enemy.get_instance_id()) #Remove enemy from list
	#print("Enemy left: ", contacting)
