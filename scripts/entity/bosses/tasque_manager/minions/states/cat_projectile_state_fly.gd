extends MinionStateBase

func start() -> void:
	minion.set_contact_damage(true)

func on_physics_process(delta: float) -> void:
	super(delta)

	if minion.get_slide_collision_count() > 0 or is_state_time_over(delta):
		minion.dismiss()
