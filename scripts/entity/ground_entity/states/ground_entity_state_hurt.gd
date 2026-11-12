extends GroundEntityStateBase

func start() -> void:
	entity.animated_sprite.play(Entity.Anim.IDLE)

func on_physics_process(delta: float) -> void:
	super(delta)

	if entity.is_on_floor():
		entity.handle_friction(Entity.Acceleration.HIGH)

	if is_state_time_over(delta) and entity.is_on_floor():
		state_machine.change_state(Entity.State.IDLE)
