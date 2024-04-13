extends Enemy

@export var projectile : PackedScene

var RANGED_VELOCITY_MULT

func set_stats():
	MAX_HP = 2
	SPEED = 70
	XP = 1
	DMG_CONTACT = 1
	DMG_RANGED = 1
	RANGED_VELOCITY_MULT = 1

func _process(delta):
	#Ranged enemy: Check distance to player
	var player_pos = get_parent().get_node("Player").position
	var distance_to_player = player_pos.distance_to(position)

	if (distance_to_player > 400):
		isChasingPlayer = true
	else:
		isChasingPlayer = false

	super._process(delta) #Animation and movement code

func start():
	$AttackCooldown.one_shot = true
	$AttackCooldown.wait_time = randf_range(0.7,4)
	$AttackCooldown.start()
	super.start() #Call the rest of the parent start code

func _on_attack_cooldown_timeout():
	if get_parent().get_node("Player").alive == false or isMoving == false:
		return #Don't shoot if player is dead or game is won

	shoot()

	#Resume timer
	$AttackCooldown.wait_time = randi_range(2,3)
	$AttackCooldown.start()

func shoot():
	var firedBullet = projectile.instantiate()
	var direction = get_parent().get_node("Player").position - position
	direction = direction.rotated((randf()-0.5)/2)
	firedBullet.position = position
	firedBullet.velocity = direction.normalized()*100*RANGED_VELOCITY_MULT
	firedBullet.DMG = DMG_RANGED
	add_sibling(firedBullet)
