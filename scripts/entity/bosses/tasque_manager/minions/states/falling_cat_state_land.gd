extends MinionStateBase

func start() -> void:
	minion.set_contact_damage(false)
	minion.state_timer = (minion as FallingCat).rest_duration
	minion.multi_sound_2d.play(FallingCat.Sound.LAND)
	minion.multi_particle_2d.emit(FallingCat.Particle.LAND, minion.global_position)

func on_physics_process(delta: float) -> void:
	super(delta)

	if is_state_time_over(delta):
		state_machine.change_state(Minion.MinionState.LEAVE)
