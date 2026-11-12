extends PlayerStateGround

const STEP_FRAMES: Array[int] = [0, 2]

var last_frame: int = -1

func start() -> void:
	last_frame = -1
	player.animated_sprite.play(Player.Anim.WALK)

func on_ground_process() -> void:
	player.handle_movement(player.speed_force * player.Acceleration.HIGH)
	update_footsteps()

	if !player.get_move_axis():
		state_machine.change_state(Player.State.IDLE)

func update_footsteps() -> void:
	var current_frame: int = player.animated_sprite.frame

	if current_frame != last_frame and current_frame in STEP_FRAMES:
		player.play_feedback(Player.Sound.STEP, Player.Particle.STEP)

	last_frame = current_frame
