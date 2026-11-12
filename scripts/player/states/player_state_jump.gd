extends PlayerStateAir

var jump_timer: float = 0.0

func start() -> void:
	jump_timer = 0.0
	player.velocity.y = player.jump_force
	player.animated_sprite.play(Player.Anim.JUMP)
	VFX.squash(player.animated_sprite)
	player.play_feedback(Player.Sound.JUMP, Player.Particle.JUMP)

func on_physics_process(delta: float) -> void:
	super(delta)

	if (Input.is_action_pressed(InputNames.Move.JUMP)
		and jump_timer < Player.JUMP_DURATION
		and player.velocity.y <= 0
		and !player.is_on_floor()):
		player.velocity.y += Player.JUMP_HOLD_FORCE * delta
		jump_timer += delta
		return

	state_machine.change_state(player.get_resting_state())
