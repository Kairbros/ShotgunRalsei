extends PlayerStateGround

func start() -> void:
	player.animated_sprite.play(Player.Anim.TAUNT)
	VFX.squash(player.animated_sprite)

func on_ground_process() -> void:
	player.handle_friction(player.Acceleration.HIGH)

	if player.get_move_axis():
		state_machine.change_state(Player.State.WALK)
		return

	if !Input.is_action_pressed(InputNames.Emote.TAUNT):
		state_machine.change_state(Player.State.IDLE)
