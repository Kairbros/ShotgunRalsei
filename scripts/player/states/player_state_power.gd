extends PlayerStateAction

const COMPLETED_HEAL: int = 30
const INTERRUPTED_HEAL: int = 5
const INTERRUPTED_POWER: int = 50

var completed: bool = false

func start() -> void:
	completed = false
	player.velocity.x = 0.0
	player.animated_sprite.play(Player.Anim.POWER)
	VFX.squash(player.animated_sprite)
	player.multi_particle_2d.emit(
		Player.Particle.CHARGE, player.global_position + Player.BODY_CENTER)

func finish() -> void:
	completed = true
	player.power_meter.set_power(0)
	player.heal(COMPLETED_HEAL)
	VFX.flash(player.animated_sprite)
	player.shake_camera(Player.ShakeMagnitude.POWER)
	super()

func exit() -> void:
	if completed or !player.is_alive():
		return

	player.power_meter.set_power(INTERRUPTED_POWER)
	player.heal(INTERRUPTED_HEAL)
