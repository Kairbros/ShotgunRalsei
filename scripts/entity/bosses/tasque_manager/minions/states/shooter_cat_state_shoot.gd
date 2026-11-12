extends MinionStateBase

func start() -> void:
	minion.animated_sprite.play(ShooterCat.Anim.ATTACK)
	VFX.squash(minion.animated_sprite)
	(minion as ShooterCat).fire()

func on_physics_process(delta: float) -> void:
	super(delta)

	if !minion.animated_sprite.is_playing():
		state_machine.change_state(Minion.MinionState.LEAVE)
