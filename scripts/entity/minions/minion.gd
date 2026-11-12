class_name Minion
extends Enemy

class MinionState:
	const STUNNED: StringName = &"Stunned"
	const LEAVE: StringName = &"Leave"
	const DEAD: StringName = &"Dead"

@export var body_center: Vector2 = Vector2(0, -16)

var target: Player = null

func spawn(_summoner_position: Vector2, new_target: Player, _floor_span: Vector2) -> void:
	target = new_target

func move(_delta: float) -> void:
	move_and_slide()

func react_to_damage(_damage: int, _damage_origin: Vector2, _knockback_force: float) -> void:
	if !is_alive():
		state_machine.change_state(MinionState.DEAD)

func stun(duration: float) -> void:
	if is_active():
		enter_timed_state(MinionState.STUNNED, duration)

func dismiss() -> void:
	if is_active():
		state_machine.change_state(MinionState.LEAVE)

func is_active() -> bool:
	var current_state: StateBase = state_machine.current_state
	return is_alive() and !(current_state is MinionStateVanish)

func face_target() -> void:
	if target:
		handle_rotation(signf(target.global_position.x - global_position.x))
