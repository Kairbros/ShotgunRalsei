extends PlayerStateAction

const PARRY_HEAL: int = 5
const PARRY_STUN_DURATION: float = 1.5
const PARRY_HIT_STOP_DURATION: float = 0.12

func start() -> void:
	player.velocity.x = 0.0
	player.shield_cooldown.start()
	player.animated_sprite.play(Player.Anim.SHIELD)
	VFX.squash(player.animated_sprite)
	player.parry_area_collider.set_disabled.call_deferred(false)
	player.parry_area.area_entered.connect(on_parry_area_entered)

func exit() -> void:
	player.parry_area_collider.set_disabled.call_deferred(true)
	player.parry_area.area_entered.disconnect(on_parry_area_entered)

func on_parry_area_entered(area: Area2D) -> void:
	var attacker: PhysicCharacterBody2D = area.owner as PhysicCharacterBody2D

	if !(area is Hitbox) or !attacker:
		return

	attacker.stun(PARRY_STUN_DURATION)
	player.heal(PARRY_HEAL)
	player.parry_buff.start()
	player.play_feedback(Player.Sound.PARRY, Player.Particle.PARRY, player.muzzle.global_position)
	VFX.flash(player.animated_sprite)
	player.shake_camera(Player.ShakeMagnitude.PARRY)
	GameFeeling.hit_stop(player.get_tree(), PARRY_HIT_STOP_DURATION)
