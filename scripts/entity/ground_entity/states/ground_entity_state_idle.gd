extends GroundEntityStateBase

func start() -> void:
	entity.animated_sprite.play(Entity.Anim.IDLE)

func on_physics_process(delta: float) -> void:
	super(delta)
	entity.handle_friction(Entity.Acceleration.HIGH)

	if is_state_time_over(delta) and entity.can_see_target():
		state_machine.change_state(Entity.State.CHASE)
