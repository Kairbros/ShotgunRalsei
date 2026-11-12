class_name DashCharges
extends Node

signal charges_changed(charges: int, max_charges: int)

@export var max_charges: int = 3
@export var recharge_duration: float = 1.0

var recharge_timer: float = 0.0

@onready var charges: int = max_charges

func _physics_process(delta: float) -> void:
	if is_full():
		recharge_timer = 0.0
		return

	recharge_timer = move_toward(recharge_timer, recharge_duration, delta)

	if recharge_timer >= recharge_duration:
		recharge_timer = 0.0
		set_charges(charges + 1)

func can_dash() -> bool:
	return charges > 0

func is_full() -> bool:
	return charges >= max_charges

func consume() -> void:
	set_charges(charges - 1)

func set_charges(value: int) -> void:
	charges = clampi(value, 0, max_charges)
	charges_changed.emit(charges, max_charges)
