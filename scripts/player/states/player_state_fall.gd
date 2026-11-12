extends PlayerStateAir

func start() -> void:
	if state_machine.previous_state is PlayerStateGround:
		player.coyote_time.start()

	player.animated_sprite.play(Player.Anim.JUMP)

func on_physics_process(delta: float) -> void:
	super(delta)
	player.coyote_time.update(delta)
	player.input_buffer.update(delta)

	VFX.stretch_update(
		player.animated_sprite, player.velocity.y, player.MAX_VERTICAL_VELOCITY)

	if Input.is_action_just_pressed(InputNames.Move.JUMP):
		if player.coyote_time.is_active():
			state_machine.change_state(Player.State.JUMP)
			return

		player.input_buffer.start(InputNames.Move.JUMP)

	if player.is_on_floor():
		player.play_feedback(Player.Sound.LAND, Player.Particle.LAND)
		state_machine.change_state(
			Player.State.JUMP if player.input_buffer.is_active(InputNames.Move.JUMP)
			else Player.State.IDLE)

func exit() -> void:
	player.coyote_time.end()
	player.input_buffer.end()
	VFX.end_stretch(player.animated_sprite)
