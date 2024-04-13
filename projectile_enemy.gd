extends Projectile

func _on_hitbox_entered(player):
	if (player.get_parent().hurtCooldownTimer == 0):
		player.get_parent().process_hit(DMG)
		queue_free() #Don't destroy if not processed

func process_hit(dmg):
	queue_free()
