class_name CameraPlayer
extends Camera2D

const PLAYER_OFFSET: Vector2 = Vector2(0, -32)

@export var camera_velocity: float = 4.25
@export var player: Player

var shake_tween: Tween = null

func _ready() -> void:
	top_level = true
	global_position = get_follow_position()

func _physics_process(delta: float) -> void:
	global_position = global_position.lerp(get_follow_position(), delta * camera_velocity)

func get_follow_position() -> Vector2:
	return player.global_position + PLAYER_OFFSET

func set_limits(bounds: Rect2i) -> void:
	limit_left = bounds.position.x
	limit_top = bounds.position.y
	limit_right = bounds.end.x
	limit_bottom = bounds.end.y

func camera_shake(duration: float, magnitude: float) -> void:
	if shake_tween:
		shake_tween.kill()

	shake_tween = create_tween()
	shake_tween.tween_method(set_shake_offset, magnitude, 0.0, duration).set_trans(
		Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

func set_shake_offset(magnitude: float) -> void:
	offset = Vector2(randf_range(-magnitude, magnitude), randf_range(-magnitude, magnitude)).round()
