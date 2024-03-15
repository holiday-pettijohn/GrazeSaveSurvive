extends Entity

@export var projectile : PackedScene

signal hit
signal death

var screen_size

var hp
var xp_mult
var melee_atk
var ranged_atk
var defense

var xp
var level

var alive

var ranged_cooldown

var current_ranged_cooldown

var velocity

func set_stats():
	#Player Stats (from parent)
	MAX_HP = 5
	SPEED = 300
	
	melee_atk = 0
	ranged_atk = 5
	
	level = 1
	
	ranged_cooldown = 0.4
	current_ranged_cooldown = 0
	
	#Player-specific stats
	xp = 0
	
	#Assigning values
	hp = MAX_HP
	alive = true

func start(start_position):
	position = start_position
	velocity = Vector2.ZERO
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
	if (hp <= 0):
		$PlayerSprite.animation = "death"
		death.emit()
	process_cooldowns(delta)
	
func process_cooldowns(delta):
	if current_ranged_cooldown > 0:
		current_ranged_cooldown -= delta

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
			
		if Input.is_action_pressed("ranged_attack") and current_ranged_cooldown <= 0:
			current_ranged_cooldown = ranged_cooldown
			ranged_attack()
		
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
	firedBullet.DMG = ranged_atk
	
	add_sibling(firedBullet)


func gain_xp(amount):
	xp += amount
	while xp >= level_threshold(level):
		level_up()
		
func level_up():
	xp -= level_threshold(level)
	level += 1
	melee_atk += 1
	ranged_atk += 1
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
