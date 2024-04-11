extends Enemy

@export var projectile : PackedScene

func set_stats():
	MAX_HP = 1
	SPEED = 70
	XP = 1
	DMG_CONTACT = 1
	DMG_RANGED = 1
	
func _process(delta):
	#Ranged enemy: Check distance to player
	var player_pos = get_parent().get_node("Player").position
	var distance_to_player = player_pos.distance_to(position)
	
	if (distance_to_player > 400):
		isMoving = true
	else:
		isMoving = false
	
	super._process(delta) #Animation and movement code
	
func start():
	$AttackCooldown.one_shot = true
	$AttackCooldown.wait_time = randi_range(3,6)
	$AttackCooldown.start()
	super.start() #Call the rest of the parent start code

func _on_attack_cooldown_timeout():
	if get_parent().get_node("Player").alive == false:
		return #Don't shoot if player is dead
	
	shoot()
	
	#Resume timer
	$AttackCooldown.wait_time = randi_range(2,3)
	$AttackCooldown.start()

func shoot():
	var firedBullet = projectile.instantiate()
	var direction = get_parent().get_node("Player").position - position
	firedBullet.position = position
	firedBullet.velocity = direction.normalized()*100
	firedBullet.DMG = DMG_RANGED
	add_sibling(firedBullet)
