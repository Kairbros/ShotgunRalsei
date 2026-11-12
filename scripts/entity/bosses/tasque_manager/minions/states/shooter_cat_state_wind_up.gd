extends MinionStateBase

func start() -> void:
	minion.set_vulnerable(true)
	minion.set_contact_damage(true)
	minion.animated_sprite.play(ShooterCat.Anim.WIND_UP)

func on_physics_process(delta: float) -> void:
	super(delta)
	minion.face_target()

	if !minion.animated_sprite.is_playing():
		state_machine.change_state(ShooterCat.State.SHOOT)
