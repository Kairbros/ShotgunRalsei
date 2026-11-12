extends MinionStateBase

func start() -> void:
	minion.graphics.hide()
	minion.set_vulnerable(false)
	minion.set_contact_damage(false)
	minion.state_timer = (minion as FallingCat).warning_duration

func on_physics_process(delta: float) -> void:
	if is_state_time_over(delta):
		state_machine.change_state(FallingCat.State.FALL)
