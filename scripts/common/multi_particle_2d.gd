class_name MultiParticle2D
extends Node2D

const NO_AVAILABLE_EMITTER_ERROR: String = "No available emitter found for name: "

@export var quantity_of_emitters: int = 4
@export var particle_scenes: Array[PackedScene] = []

var emitters_by_name: Dictionary[StringName, Array] = {}
var emitters_start_time: Dictionary[CPUParticles2D, int] = {}

func _ready() -> void:
	for scene: PackedScene in particle_scenes:
		var particle_name: StringName = scene.get_state().get_node_name(0)
		emitters_by_name[particle_name] = []

		for index: int in quantity_of_emitters:
			var emitter: CPUParticles2D = scene.instantiate()
			emitter.name = particle_name + str(index)
			add_child(emitter)
			emitters_by_name[particle_name].append(emitter)

func emit(particle_name: StringName, start_position: Vector2, facing: float = 1.0) -> void:
	var emitter: CPUParticles2D = find_available_emitter(particle_name)

	if !emitter:
		push_error(NO_AVAILABLE_EMITTER_ERROR + particle_name)
		return

	emitter.global_position = start_position
	emitter.scale.x = facing
	emitter.restart()
	emitters_start_time[emitter] = Time.get_ticks_msec()

	for sub_emitter: CPUParticles2D in emitter.find_children("*", "CPUParticles2D", true, false):
		sub_emitter.restart()

func find_available_emitter(particle_name: StringName) -> CPUParticles2D:
	var oldest: CPUParticles2D = null
	var oldest_time: int = Time.get_ticks_msec() + 1

	for emitter: CPUParticles2D in emitters_by_name.get(particle_name, []):
		if !emitter.emitting:
			return emitter

		var start_time: int = emitters_start_time.get(emitter, 0)
		if start_time < oldest_time:
			oldest_time = start_time
			oldest = emitter

	return oldest
