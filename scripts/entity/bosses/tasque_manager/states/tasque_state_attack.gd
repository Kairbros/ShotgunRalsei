extends TasqueStateBase

var spawn_timer: float = 0.0

func start() -> void:
	boss.set_dash_pose(false)

	if boss.update_phase():
		spawn_timer = boss.get_phase().opening_delay

func on_physics_process(delta: float) -> void:
	super(delta)
	boss.handle_friction(Enemy.Acceleration.HIGH)

	if !boss.target.is_alive():
		return

	boss.face_target()

	if boss.update_phase():
		spawn_timer = boss.get_phase().opening_delay

	if boss.wants_dash():
		state_machine.change_state(TasqueManager.State.DASH_WIND_UP)
		return

	spawn_timer = move_toward(spawn_timer, 0.0, delta)

	if spawn_timer <= 0.0:
		boss.summon()
		spawn_timer = boss.get_spawn_interval()
