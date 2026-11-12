class_name Countdown
extends Node

signal running_changed(is_running: bool)

@export var duration: float = 1.0

var time_left: float = 0.0

func _physics_process(delta: float) -> void:
	if !is_running():
		return

	time_left = move_toward(time_left, 0.0, delta)

	if !is_running():
		running_changed.emit(false)

func start() -> void:
	time_left = duration
	running_changed.emit(true)

func is_running() -> bool:
	return time_left > 0.0
