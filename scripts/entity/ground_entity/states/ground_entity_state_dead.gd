extends GroundEntityStateBase

func start() -> void:
	entity.particles.hide()
	VFX.stop_blink(entity.animated_sprite)
	entity.explode(Entity.Particle.POOF, Entity.BODY_CENTER)

func on_physics_process(delta: float) -> void:
	super(delta)
	entity.handle_friction(Entity.Acceleration.MEDIUM)
