class_name PlayerStateBase
extends StateBase

@export var invulnerable: bool = false

var player: Player:
	get():
		return state_machine.controlled_node

func on_physics_process(_delta: float) -> void:
	player.move_and_slide()
	player.handle_gravity()

func on_unhandled_input(event: InputEvent) -> void:
	var requested_state: StringName = get_requested_state(event)

	if requested_state:
		state_machine.change_state(requested_state)

func get_requested_state(_event: InputEvent) -> StringName:
	return &""

func get_mobility_request(event: InputEvent) -> StringName:
	if event.is_action_pressed(InputNames.Move.JUMP) and player.is_on_floor():
		return Player.State.JUMP

	if event.is_action_pressed(InputNames.Move.DASH) and player.dash_charges.can_dash():
		return Player.State.DASH

	return &""
