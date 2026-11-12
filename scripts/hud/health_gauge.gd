class_name HealthGauge
extends Control

const COUNTER_FORMAT: String = "%d / %d"

@export var warning_ratio: float = 0.25

@onready var bar: HudBar = $Bar
@onready var counter: Label = $Counter

func set_health(health: int, max_health: int, instant: bool = false) -> void:
	bar.set_values(health, max_health, instant)
	counter.text = COUNTER_FORMAT % [health, max_health]
	var in_danger: bool = health > 0 and bar.get_ratio() <= warning_ratio
	bar.set_pulsing(in_danger)
	counter.self_modulate = (
		HudPalette.RED if health <= 0
		else HudPalette.YELLOW if in_danger
		else HudPalette.WHITE)

func flash() -> void:
	VFX.flash(bar)
