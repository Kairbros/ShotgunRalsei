extends TasqueStateBase

var afterimage_timer: float = 0.0

func start() -> void:
	afterimage_timer = 0.0
	boss.state_timer = boss.dash_duration
	boss.velocity.x = boss.get_facing() * boss.dash_speed
	boss.set_dash_pose(true)
	boss.set_contact_damage_amount(boss.dash_contact_damage)
	boss.multi_particle_2d.emit(TasqueManager.Particle.DASH, boss.global_position, boss.get_facing())
	boss.shake_screen()

func on_physics_process(delta: float) -> void:
	super(delta)

	if boss.is_on_wall():
		boss.velocity.x = -boss.get_facing() * boss.dash_speed
		boss.handle_rotation(signf(boss.velocity.x))
		boss.shake_screen()

	afterimage_timer = move_toward(afterimage_timer, 0.0, delta)

	if afterimage_timer <= 0.0:
		afterimage_timer = boss.afterimage_interval
		boss.spawn_afterimage()

	if is_state_time_over(delta):
		boss.call_reinforcement()
		state_machine.change_state(TasqueManager.State.ATTACK)

func exit() -> void:
	boss.velocity.x = 0.0
	boss.set_contact_damage_amount(boss.damage_amount)
	boss.multi_particle_2d.emit(TasqueManager.Particle.LAND, boss.global_position)
