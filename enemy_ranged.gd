extends Enemy

func set_stats():
	MAX_HP = 1
	SPEED = 70
	XP = 1
	DMG_CONTACT = 1
	DMG_RANGED = 1
	
func _process(delta):
	var player_pos = get_parent().get_node("Player").position
	var distance_to_player = player_pos.distance_to(position)
	
	if (distance_to_player > 400):
		isMoving = true
	else:
		isMoving = false
	
	super._process(delta)
