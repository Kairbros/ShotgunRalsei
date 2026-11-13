class_name MinionStateShatter
extends MinionStateBase

@export var particle_name: StringName = &""

func start() -> void:
	minion.velocity = Vector2.ZERO
	VFX.stop_blink(minion.animated_sprite)
	minion.explode(particle_name, minion.body_center)
