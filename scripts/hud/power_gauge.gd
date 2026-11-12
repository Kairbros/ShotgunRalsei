class_name PowerGauge
extends Control

const PERCENT_FORMAT: String = "%d%%"
const FULL_TEXT: String = "MAX"
const PERCENT_SCALE: float = 100.0

@export var charging_color: Color = Color.WHITE
@export var full_color: Color = Color.WHITE

@onready var bar: HudBar = $Bar
@onready var amount_label: Label = $Amount

func set_power(power: int, max_power: int, instant: bool = false) -> void:
	var was_full: bool = bar.is_pulsing()
	var full: bool = power >= max_power
	bar.set_values(power, max_power, instant)
	bar.set_fill_color(full_color if full else charging_color)
	bar.set_pulsing(full)
	amount_label.text = (
		FULL_TEXT if full
		else PERCENT_FORMAT % roundi(bar.get_ratio() * PERCENT_SCALE))
	amount_label.self_modulate = HudPalette.YELLOW if full else HudPalette.WHITE

	if full and !was_full and !instant:
		VFX.flash(bar)
		VFX.flash(amount_label)
