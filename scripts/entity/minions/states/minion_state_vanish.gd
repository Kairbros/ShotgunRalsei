class_name MinionStateVanish
extends MinionStateBase

@export var particle_name: StringName = &""
@export var drift: Vector2 = Vector2.ZERO

func start() -> void:
	minion.set_contact_damage(false)
	minion.set_vulnerable(false)
	minion.velocity = Vector2.ZERO
	minion.animated_sprite.pause()

	if particle_name:
		minion.multi_particle_2d.emit(particle_name, minion.global_position + minion.body_center)

	minion.create_tween().tween_method(set_drift, Vector2.ZERO, drift, VFX.DISSOLVE_DURATION)
	VFX.dissolve(minion.animated_sprite).finished.connect(minion.queue_free)

func set_drift(offset: Vector2) -> void:
	minion.animated_sprite.position = offset.round()
