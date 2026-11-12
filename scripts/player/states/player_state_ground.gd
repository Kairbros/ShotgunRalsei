class_name PlayerStateGround
extends PlayerStateBase

func on_physics_process(delta: float) -> void:
	super(delta)
	player.handle_rotation()

	if !player.is_on_floor():
		state_machine.change_state(Player.State.FALL)
		return

	on_ground_process()

func on_ground_process() -> void:
	pass

func get_requested_state(event: InputEvent) -> StringName:
	var mobility_request: StringName = get_mobility_request(event)

	if mobility_request:
		return mobility_request

	if event.is_action_pressed(InputNames.Fight.ATTACK):
		return Player.State.SHOOT

	if event.is_action_pressed(InputNames.Fight.SHIELD) and !player.shield_cooldown.is_running():
		return Player.State.SHIELD

	if event.is_action_pressed(InputNames.Fight.POWER) and player.power_meter.is_full():
		return Player.State.POWER

	return &""
