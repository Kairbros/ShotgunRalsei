class_name PowerMeter
extends Node

signal power_changed(power: int, max_power: int)

@export var max_power: int = 100
@export var power_per_hit: int = 10

var power: int = 0

func charge() -> void:
	set_power(power + power_per_hit)

func set_power(value: int) -> void:
	power = clampi(value, 0, max_power)
	power_changed.emit(power, max_power)

func is_full() -> bool:
	return power >= max_power
