class_name PlayerStateAir
extends PlayerStateBase

func on_physics_process(delta: float) -> void:
	super(delta)
	player.handle_rotation()

	if player.get_move_axis():
		player.handle_movement(player.speed_force * player.Acceleration.MEDIUM)

	else:
		player.handle_friction(player.Acceleration.LOW)

func get_requested_state(event: InputEvent) -> StringName:
	return get_mobility_request(event)
