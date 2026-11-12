extends PlayerStateAction

func start() -> void:
	player.hurt_invulnerability.start()
	VFX.flash(player.animated_sprite)
	VFX.blink(player.animated_sprite, player.hurt_invulnerability.duration)
	player.animated_sprite.play(Player.Anim.HURT)
	VFX.squash(player.animated_sprite)
	player.play_feedback(
		Player.Sound.HURT, Player.Particle.HIT, player.global_position + Player.BODY_CENTER)
	player.shake_camera(Player.ShakeMagnitude.HURT)
