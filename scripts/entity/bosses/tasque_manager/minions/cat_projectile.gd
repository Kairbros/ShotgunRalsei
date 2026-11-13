class_name CatProjectile
extends Minion

class State:
	const FLY: StringName = &"Fly"

@export var speed: float = 150.0
@export var lifetime: float = 3.5

func launch(from: Vector2, new_target: Player) -> void:
	target = new_target
	global_position = from
	var aim: Vector2 = target.global_position + Player.BODY_CENTER
	aim.x = predict_target_x(from.distance_to(aim) / speed)
	var direction: Vector2 = from.direction_to(aim)
	velocity = direction * speed
	graphics.rotation = direction.angle()
	state_timer = lifetime

func stun(_duration: float) -> void:
	dismiss()

func on_hit_landed(_hurtbox: Hurtbox) -> void:
	dismiss()

func dismiss() -> void:
	if is_active():
		state_machine.change_state(MinionState.DEAD)
