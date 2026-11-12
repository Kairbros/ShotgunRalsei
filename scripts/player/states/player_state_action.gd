class_name PlayerStateAction
extends PlayerStateBase

func on_physics_process(delta: float) -> void:
	super(delta)
	on_action_process(delta)

	if !player.animated_sprite.is_playing():
		finish()

func on_action_process(_delta: float) -> void:
	player.handle_friction(
		player.Acceleration.HIGH if player.is_on_floor() else player.Acceleration.LOW)

func finish() -> void:
	state_machine.change_state(player.get_resting_state())
