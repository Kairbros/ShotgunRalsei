extends TasqueStateBase

const TREMBLE_SPEED: float = 60.0

var dash_direction: float = 1.0
var elapsed: float = 0.0

func start() -> void:
	elapsed = 0.0
	boss.damage_since_dash = 0
	boss.state_timer = boss.dash_wind_up_duration
	dash_direction = boss.pick_dash_direction()
	boss.handle_rotation(dash_direction)
	boss.multi_sound_2d.play(TasqueManager.Voice.DASH)
	VFX.flash(boss.animated_sprite, boss.dash_wind_up_duration)

func on_physics_process(delta: float) -> void:
	super(delta)
	elapsed += delta
	boss.animated_sprite.position.x = roundf(sin(elapsed * TREMBLE_SPEED))

	if is_state_time_over(delta):
		state_machine.change_state(TasqueManager.State.DASH)

func exit() -> void:
	boss.animated_sprite.position.x = 0.0
