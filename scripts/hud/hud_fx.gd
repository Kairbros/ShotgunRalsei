class_name HudFx

const SHAKE_DURATION: float = 0.3
const POP_DURATION: float = 0.15
const POP_OFFSET: Vector2 = Vector2(0.0, 4.0)
const RAINBOW_CYCLES_PER_SECOND: float = 3.0
const RAINBOW_SATURATION: float = 0.6
const BRIGHT_FLASH_COLOR: Color = Color(3.0, 3.0, 3.0)
const TYPE_CHARACTER_DURATION: float = 0.04

class Property:
	const MODULATE: NodePath = ^"modulate"
	const VALUE: NodePath = ^"value"
	const VISIBLE_CHARACTERS: NodePath = ^"visible_characters"

class Meta:
	const REST_POSITION: StringName = &"hud_fx_rest_position"
	const SHAKE_TWEEN: StringName = &"hud_fx_shake_tween"
	const POP_TWEEN: StringName = &"hud_fx_pop_tween"
	const FILL_TWEEN: StringName = &"hud_fx_fill_tween"
	const RAINBOW_TWEEN: StringName = &"hud_fx_rainbow_tween"
	const BRIGHT_FLASH_TWEEN: StringName = &"hud_fx_bright_flash_tween"
	const TYPE_TWEEN: StringName = &"hud_fx_type_tween"

static func get_rest_position(target: Control) -> Vector2:
	if !target.has_meta(Meta.REST_POSITION):
		target.set_meta(Meta.REST_POSITION, target.position)

	return target.get_meta(Meta.REST_POSITION)

static func shake(target: Control, magnitude: float, duration: float = SHAKE_DURATION) -> void:
	var rest_position: Vector2 = get_rest_position(target)
	var shake_tween: Tween = VFX.replace_tween(target, Meta.SHAKE_TWEEN)
	shake_tween.tween_method(
		set_shake_offset.bind(target, rest_position), magnitude, 0.0, duration).set_trans(
			Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	shake_tween.tween_callback(target.set_position.bind(rest_position))

static func set_shake_offset(magnitude: float, target: Control, rest_position: Vector2) -> void:
	target.position = rest_position + Vector2(
		randf_range(-magnitude, magnitude), randf_range(-magnitude, magnitude)).round()

static func pop_in(target: Control) -> void:
	var rest_position: Vector2 = get_rest_position(target)
	var pop_tween: Tween = VFX.replace_tween(target, Meta.POP_TWEEN)
	target.show()
	target.modulate = HudPalette.FADED
	target.position = rest_position + POP_OFFSET
	pop_tween.set_parallel().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	pop_tween.tween_property(target, Property.MODULATE, HudPalette.WHITE, POP_DURATION)
	pop_tween.tween_method(
		set_snapped_position.bind(target), target.position, rest_position, POP_DURATION)

static func pop_out(target: Control) -> void:
	var rest_position: Vector2 = get_rest_position(target)
	var pop_tween: Tween = VFX.replace_tween(target, Meta.POP_TWEEN)
	pop_tween.set_parallel().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN)
	pop_tween.tween_property(target, Property.MODULATE, HudPalette.FADED, POP_DURATION)
	pop_tween.tween_method(
		set_snapped_position.bind(target),
		target.position,
		rest_position + POP_OFFSET,
		POP_DURATION)
	pop_tween.chain().tween_callback(target.hide)
	pop_tween.tween_callback(target.set_position.bind(rest_position))

static func set_snapped_position(new_position: Vector2, target: Control) -> void:
	target.position = new_position.round()

static func fill(target: Range, from_ratio: float, duration: float) -> void:
	var fill_tween: Tween = VFX.replace_tween(target, Meta.FILL_TWEEN)
	fill_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	fill_tween.tween_property(target, Property.VALUE, target.max_value, duration).from(
		lerpf(target.min_value, target.max_value, from_ratio))

static func stop_fill(target: Range) -> void:
	VFX.kill_tween(target, Meta.FILL_TWEEN)

static func rainbow(target: CanvasItem, duration: float) -> void:
	var rainbow_tween: Tween = VFX.replace_tween(target, Meta.RAINBOW_TWEEN)
	rainbow_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	rainbow_tween.tween_method(
		set_rainbow_tint.bind(target), duration * RAINBOW_CYCLES_PER_SECOND, 0.0, duration)
	rainbow_tween.tween_callback(target.set_self_modulate.bind(HudPalette.WHITE))

static func stop_rainbow(target: CanvasItem) -> void:
	VFX.kill_tween(target, Meta.RAINBOW_TWEEN)
	target.self_modulate = HudPalette.WHITE

static func set_rainbow_tint(cycles: float, target: CanvasItem) -> void:
	target.self_modulate = Color.from_hsv(fposmod(cycles, 1.0), RAINBOW_SATURATION, 1.0)

static func bright_flash(target: CanvasItem, duration: float = VFX.FLASH_DURATION) -> void:
	var flash_tween: Tween = VFX.replace_tween(target, Meta.BRIGHT_FLASH_TWEEN)
	flash_tween.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
	flash_tween.tween_property(target, Property.MODULATE, HudPalette.WHITE, duration).from(
		BRIGHT_FLASH_COLOR)

static func type_text(target: Label, voice: AudioStreamPlayer, line: String) -> Tween:
	var type_tween: Tween = VFX.replace_tween(target, Meta.TYPE_TWEEN)
	target.text = line
	target.visible_characters = 0
	voice.play()
	type_tween.tween_property(
		target, Property.VISIBLE_CHARACTERS, line.length(), line.length() * TYPE_CHARACTER_DURATION)
	type_tween.tween_callback(voice.stop)
	return type_tween
