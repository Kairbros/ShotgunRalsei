extends PlayerStateAction

const DASH_SPEED: float = 480.0
const GHOST_TRAIL_INTERVAL: float = 0.025

var dash_direction: float = 1.0
var ghost_trail_timer: float = 0.0

func start() -> void:
	dash_direction = player.get_move_axis() if player.get_move_axis() else player.get_facing()
	ghost_trail_timer = 0.0

	player.handle_rotation(dash_direction)
	player.dash_charges.consume()
	player.animated_sprite.play(Player.Anim.DASH)
	VFX.squash(player.animated_sprite)
	player.play_feedback(Player.Sound.DASH, Player.Particle.DASH)
	player.shake_camera(Player.ShakeMagnitude.DASH)
	spawn_ghost_trail()

func on_action_process(delta: float) -> void:
	player.velocity = Vector2(dash_direction * DASH_SPEED, 0.0)
	ghost_trail_timer = move_toward(ghost_trail_timer, GHOST_TRAIL_INTERVAL, delta)

	if ghost_trail_timer >= GHOST_TRAIL_INTERVAL:
		ghost_trail_timer = 0.0
		spawn_ghost_trail()

func get_requested_state(event: InputEvent) -> StringName:
	return Player.State.JUMP if get_mobility_request(event) == Player.State.JUMP else &""

func exit() -> void:
	player.velocity.x = dash_direction * player.speed_force

func spawn_ghost_trail() -> void:
	GhostTrail.spawn(player.animated_sprite, player)
