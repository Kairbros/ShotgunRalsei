class_name GameFeeling

const HIT_STOP_TIME_SCALE: float = 0.05
const NORMAL_TIME_SCALE: float = 1.0

class CoyoteTime:
	const DURATION: float = 0.15

	var timer: float = 0.0

	func start() -> void:
		timer = DURATION

	func is_active() -> bool:
		return timer > 0.0

	func update(delta: float) -> void:
		timer = move_toward(timer, 0.0, delta)

	func end() -> void:
		timer = 0.0

class InputBuffer:
	const DURATION: float = 0.15

	var input_type: StringName = &""
	var timer: float = 0.0

	func start(buffered_input: StringName) -> void:
		input_type = buffered_input
		timer = DURATION

	func is_active(buffered_input: StringName) -> bool:
		return input_type == buffered_input

	func update(delta: float) -> void:
		timer = move_toward(timer, 0.0, delta)

		if timer <= 0.0:
			end()

	func end() -> void:
		timer = 0.0
		input_type = &""

static func hit_stop(tree: SceneTree, duration: float) -> void:
	Engine.time_scale = HIT_STOP_TIME_SCALE
	tree.create_timer(duration, true, false, true).timeout.connect(end_hit_stop)

static func end_hit_stop() -> void:
	Engine.time_scale = NORMAL_TIME_SCALE
