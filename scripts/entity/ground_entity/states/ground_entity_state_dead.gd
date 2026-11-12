extends GroundEntityStateBase

func start() -> void:
	entity.set_contact_damage(false)
	entity.set_vulnerable(false)
	entity.animated_sprite.pause()
	entity.particles.hide()
	VFX.stop_blink(entity.animated_sprite)
	entity.multi_particle_2d.emit(Entity.Particle.POOF, entity.global_position + Entity.BODY_CENTER)
	VFX.dissolve(entity.animated_sprite).finished.connect(entity.queue_free)

func on_physics_process(delta: float) -> void:
	super(delta)
	entity.handle_friction(Entity.Acceleration.MEDIUM)
