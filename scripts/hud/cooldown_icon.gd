class_name CooldownIcon
extends TextureProgressBar

func _init() -> void:
	fill_mode = FILL_BOTTOM_TO_TOP
	max_value = 1.0
	step = 0.0
	value = max_value
	mouse_filter = MOUSE_FILTER_IGNORE

func start_recharge(from_ratio: float, duration: float) -> void:
	tint_progress = HudPalette.RECHARGING
	HudFx.fill(self, from_ratio, duration)

func set_ready(announce: bool) -> void:
	HudFx.stop_fill(self)
	value = max_value
	tint_progress = HudPalette.WHITE

	if announce:
		VFX.flash(self)

func set_empty() -> void:
	HudFx.stop_fill(self)
	value = min_value

func is_ready() -> bool:
	return value >= max_value and tint_progress == HudPalette.WHITE
