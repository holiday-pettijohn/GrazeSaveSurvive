extends Entity #Inherit from Entity class
class_name Enemy

@export var xp_scene : PackedScene
@export var tile : PackedScene

signal hit
signal death

@onready var dieSound = $DeathSound
@export var XP = 0
var hp
var isContactingPlayer
var velocity
var move_vector
var isMoving : bool

func set_stats():
	#Overridden by child
	MAX_HP = 1
	SPEED = 50
	XP = 0
	DMG_CONTACT = 0
	DMG_RANGED = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	set_stats()
	start()

func start():
	$Sprite.play()
	GROUP = 2
	hp = MAX_HP
	isContactingPlayer = false
	isMoving = true
	move_vector = get_parent().get_node("Player").position - position #Face player when spawned

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	updateAnimation()
	if (get_parent().get_node("Player").alive == false) or (!isMoving):
		$Sprite.stop() #Idle
		$Sprite.frame = 0
		return

	$Sprite.play()
	move(delta)

func move(delta):
	#Default behavior: Step towards player
	move_vector = get_parent().get_node("Player").position - position #Face player always
	position += move_vector.normalized() * delta * SPEED

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

func _on_death():
	var xpOrb = xp_scene.instantiate()
	var spawnPosition = Vector2.ZERO
	xpOrb.position = self.position

	add_child(xpOrb)
	queue_free()
	dieSound.play()

func _on_hurt_area_entered(area):
	if area.get_parent().GROUP == 2:
		hp -= 1
		hit.emit()

	#Enemy death
	if (hp <= 0):
		$EnenySprite.animation = "death"
		death.emit()

func _on_melee_box_area_entered(area):
	isContactingPlayer = true
	isMoving = false
	area.get_parent().process_hit(DMG_CONTACT)

func _on_melee_box_area_exited(area):
	isContactingPlayer = false
	isMoving = true

func process_hit(dmg):
	hp -= dmg

	if (hp <= 0):
		#Drop XP on death - Move to main function
		var newXpOrb = xp_scene.instantiate()
		newXpOrb.global_position = self.global_position
		newXpOrb.amount = XP
		add_sibling(newXpOrb)# - Must move this to the main function!
		if (randi() % 5 == 0):
			var newTile = tile.instantiate()
			newTile.generate_tile(-1)
			add_sibling(newTile)
			newTile.global_position = self.global_position
			newTile.render_tiles()
		death.emit()
		queue_free()
