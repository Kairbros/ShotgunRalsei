extends MinionStateBase

func start() -> void:
	minion.graphics.show()
	minion.face_target()
	minion.set_vulnerable(true)
	minion.set_contact_damage(true)
	minion.animated_sprite.play(FallingCat.Anim.FALL)

func on_physics_process(delta: float) -> void:
	super(delta)
	VFX.stretch_update(minion.animated_sprite, minion.velocity.y, Minion.MAX_VERTICAL_VELOCITY)

	if minion.is_on_floor():
		state_machine.change_state(FallingCat.State.LAND)

func exit() -> void:
	VFX.end_stretch(minion.animated_sprite)
