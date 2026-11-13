extends TasqueStateBase

const ARRIVAL_DISTANCE: float = 4.0

var destination_x: float = 0.0

func start() -> void:
	destination_x = boss.pick_reposition_x()

func on_physics_process(delta: float) -> void:
	super(delta)

	if boss.wants_dash():
		state_machine.change_state(TasqueManager.State.DASH_WIND_UP)
		return

	var offset: float = destination_x - boss.global_position.x

	if absf(offset) <= ARRIVAL_DISTANCE:
		state_machine.change_state(TasqueManager.State.ATTACK)
		return

	boss.handle_rotation(signf(offset))
	boss.velocity.x = move_toward(
		boss.velocity.x, signf(offset) * boss.reposition_speed, boss.reposition_speed * Enemy.Acceleration.HIGH * delta)
