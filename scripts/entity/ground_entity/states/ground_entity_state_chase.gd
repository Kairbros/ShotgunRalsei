extends GroundEntityStateBase

func start() -> void:
	entity.set_contact_damage(true)

func on_physics_process(delta: float) -> void:
	super(delta)

	if !entity.can_see_target():
		entity.enter_timed_state(Entity.State.IDLE, entity.lost_target_duration)
		return

	entity.handle_rotation(entity.get_target_direction())

	if entity.is_at_ledge() or entity.is_target_close():
		entity.halt()
	else:
		entity.drive(entity.get_facing())

func exit() -> void:
	entity.set_contact_damage(false)
