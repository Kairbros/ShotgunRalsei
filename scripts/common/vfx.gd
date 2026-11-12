class_name VFX

const PIXEL_SNAP: float = 1.0 / 8.0
const SQUASH_SCALE: Vector2 = Vector2(9.0 / 8.0, 7.0 / 8.0)
const SQUASH_DURATION: float = 1.0 / 8.0
const FLASH_DURATION: float = 0.2
const DISSOLVE_DURATION: float = 0.6

class ShaderParam:
	const FLASH_AMOUNT: NodePath = ^"material:shader_parameter/flash_amount"
	const BLINKING: NodePath = ^"material:shader_parameter/blinking"
	const DISSOLVE_AMOUNT: NodePath = ^"material:shader_parameter/dissolve_amount"

class Meta:
	const SQUASH_TWEEN: StringName = &"vfx_squash_tween"
	const FLASH_TWEEN: StringName = &"vfx_flash_tween"
	const BLINK_TWEEN: StringName = &"vfx_blink_tween"

static func squash(target_node: Node2D, target_scale: Vector2 = SQUASH_SCALE) -> void:
	var squash_tween: Tween = replace_tween(target_node, Meta.SQUASH_TWEEN)
	var scale_setter: Callable = set_snapped_scale.bind(target_node)
	squash_tween.tween_method(scale_setter, Vector2.ONE, target_scale, SQUASH_DURATION)
	squash_tween.tween_method(scale_setter, target_scale, Vector2.ONE, SQUASH_DURATION)

static func set_snapped_scale(scale_value: Vector2, target_node: Node2D) -> void:
	target_node.scale = scale_value.snappedf(PIXEL_SNAP)

static func stretch_update(
	target_node: Node2D,
	velocity_y: float,
	max_velocity: float,
	max_stretch: float = PIXEL_SNAP) -> void:

	var stretch_amount: float = max_stretch * clampf(velocity_y / max_velocity, 0.0, 1.0)
	set_snapped_scale(Vector2(1.0 - stretch_amount, 1.0 + stretch_amount), target_node)

static func end_stretch(target_node: Node2D) -> void:
	squash(target_node)

static func flash(target_node: CanvasItem, duration: float = FLASH_DURATION) -> void:
	var flash_tween: Tween = replace_tween(target_node, Meta.FLASH_TWEEN)
	flash_tween.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
	flash_tween.tween_property(target_node, ShaderParam.FLASH_AMOUNT, 0.0, duration).from(1.0)

static func blink(target_node: CanvasItem, duration: float) -> void:
	var blink_tween: Tween = replace_tween(target_node, Meta.BLINK_TWEEN)
	set_blinking(target_node, true)
	blink_tween.tween_interval(duration)
	blink_tween.tween_callback(set_blinking.bind(target_node, false))

static func stop_blink(target_node: CanvasItem) -> void:
	kill_tween(target_node, Meta.BLINK_TWEEN)
	set_blinking(target_node, false)

static func set_blinking(target_node: CanvasItem, enabled: bool) -> void:
	target_node.set_indexed(ShaderParam.BLINKING, enabled)

static func dissolve(target_node: CanvasItem) -> Tween:
	var dissolve_tween: Tween = target_node.create_tween()
	dissolve_tween.tween_property(
		target_node, ShaderParam.DISSOLVE_AMOUNT, 1.0, DISSOLVE_DURATION).from(0.0)
	return dissolve_tween

static func replace_tween(target_node: CanvasItem, key: StringName) -> Tween:
	kill_tween(target_node, key)
	var new_tween: Tween = target_node.create_tween()
	target_node.set_meta(key, new_tween)
	return new_tween

static func kill_tween(target_node: CanvasItem, key: StringName) -> void:
	if target_node.has_meta(key):
		var running_tween: Tween = target_node.get_meta(key)
		running_tween.kill()
