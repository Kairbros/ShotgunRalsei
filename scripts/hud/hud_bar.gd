class_name HudBar
extends Control

const TRAIL_DELAY: float = 0.3
const TRAIL_DURATION: float = 0.35
const GAIN_DURATION: float = 0.3
const PULSE_HALF_PERIOD: float = 0.25

class Property:
	const FILL_RATIO: NodePath = ^"fill_ratio"
	const TRAIL_RATIO: NodePath = ^"trail_ratio"
	const PULSE_AMOUNT: NodePath = ^"pulse_amount"

@export var fill_color: Color = Color.WHITE
@export var back_color: Color = Color.BLACK
@export var trail_color: Color = Color.WHITE
@export var pulse_color: Color = Color.WHITE

var value: int = 0
var max_value: int = 1
var fill_ratio: float = 0.0: set = set_fill_ratio
var trail_ratio: float = 0.0: set = set_trail_ratio
var pulse_amount: float = 0.0: set = set_pulse_amount
var ratio_tween: Tween = null
var pulse_tween: Tween = null

func _draw() -> void:
	var width: int = floori(size.x)
	draw_rect(Rect2(Vector2.ZERO, size), back_color)
	draw_rect(Rect2(0.0, 0.0, ratio_to_pixels(trail_ratio, width), size.y), trail_color)
	draw_rect(
		Rect2(0.0, 0.0, ratio_to_pixels(fill_ratio, width), size.y),
		fill_color.lerp(pulse_color, pulse_amount))

func set_values(new_value: int, new_max_value: int, instant: bool = false) -> void:
	value = new_value
	max_value = maxi(new_max_value, 1)
	var target_ratio: float = get_ratio()

	if ratio_tween:
		ratio_tween.kill()

	if instant:
		fill_ratio = target_ratio
		trail_ratio = target_ratio
		return

	ratio_tween = create_tween().set_trans(Tween.TRANS_QUAD)

	if target_ratio < fill_ratio:
		trail_ratio = maxf(trail_ratio, fill_ratio)
		fill_ratio = target_ratio
		ratio_tween.tween_interval(TRAIL_DELAY)
		ratio_tween.tween_property(
			self, Property.TRAIL_RATIO, target_ratio, TRAIL_DURATION).set_ease(Tween.EASE_IN)
		return

	trail_ratio = target_ratio
	ratio_tween.tween_property(
		self, Property.FILL_RATIO, target_ratio, GAIN_DURATION).set_ease(Tween.EASE_OUT)

func get_ratio() -> float:
	return clampf(float(value) / max_value, 0.0, 1.0)

func set_fill_color(color: Color) -> void:
	fill_color = color
	queue_redraw()

func set_pulsing(enabled: bool) -> void:
	if enabled == is_pulsing():
		return

	if pulse_tween:
		pulse_tween.kill()
		pulse_tween = null

	pulse_amount = 0.0

	if !enabled:
		return

	pulse_tween = create_tween().set_loops().set_trans(Tween.TRANS_SINE)
	pulse_tween.tween_property(self, Property.PULSE_AMOUNT, 1.0, PULSE_HALF_PERIOD)
	pulse_tween.tween_property(self, Property.PULSE_AMOUNT, 0.0, PULSE_HALF_PERIOD)

func is_pulsing() -> bool:
	return pulse_tween != null

func set_fill_ratio(ratio: float) -> void:
	fill_ratio = ratio
	queue_redraw()

func set_trail_ratio(ratio: float) -> void:
	trail_ratio = ratio
	queue_redraw()

func set_pulse_amount(amount: float) -> void:
	pulse_amount = amount
	queue_redraw()

static func ratio_to_pixels(ratio: float, width: int) -> int:
	return 0 if ratio <= 0.0 else maxi(1, roundi(ratio * width))
