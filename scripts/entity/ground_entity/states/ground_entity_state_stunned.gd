extends GroundEntityStateBase

func start() -> void:
	entity.animated_sprite.play(Entity.Anim.IDLE)
	VFX.blink(entity.animated_sprite, entity.state_timer)

func on_physics_process(delta: float) -> void:
	super(delta)
	entity.handle_friction(Entity.Acceleration.HIGH)

	if is_state_time_over(delta):
		state_machine.change_state(Entity.State.IDLE)

func exit() -> void:
	VFX.stop_blink(entity.animated_sprite)
