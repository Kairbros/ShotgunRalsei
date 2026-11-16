extends TasqueStateBase

var reposition_timer: float = 0.0

func start() -> void:
	boss.set_dash_pose(false)
	boss.refresh_phase()

	if reposition_timer <= 0.0:
		reposition_timer = boss.pick_reposition_delay()

func on_physics_process(delta: float) -> void:
	super(delta)
	boss.handle_friction(Enemy.Acceleration.HIGH)

	if !boss.target.is_alive():
		return

	boss.face_target()

	if boss.wants_dash():
		state_machine.change_state(TasqueManager.State.DASH_WIND_UP)
		return

	reposition_timer = move_toward(reposition_timer, 0.0, delta)

	if reposition_timer <= 0.0:
		state_machine.change_state(TasqueManager.State.REPOSITION)
		return

	boss.update_summons(delta)
