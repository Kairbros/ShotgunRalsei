extends MinionStateBase

func start() -> void:
	minion.set_contact_damage(false)
	minion.animated_sprite.pause()
	VFX.blink(minion.animated_sprite, minion.state_timer)

func on_physics_process(delta: float) -> void:
	super(delta)

	if is_state_time_over(delta):
		state_machine.change_state(Minion.MinionState.LEAVE)

func exit() -> void:
	VFX.stop_blink(minion.animated_sprite)
