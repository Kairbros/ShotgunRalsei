class_name MultiSound2D
extends Node2D

const MAX_DISTANCE: float = 512.0
const PANNING_STRENGTH: float = 1.75
const NO_AVAILABLE_REPRODUCER_ERROR: String = "No available reproducer found for name: "

@export var quantity_of_reproducers: int = 3
@export var audio_streams: Array[AudioStream] = []
@export var bus: StringName = &"Master"
@export var pitch_variation: float = 0.0

var reproducers_by_name: Dictionary[StringName, Array] = {}

func _ready() -> void:
	for stream: AudioStream in audio_streams:
		var sound_name: StringName = stream.resource_path.get_file().get_basename().to_pascal_case()
		reproducers_by_name[sound_name] = []

		for index: int in quantity_of_reproducers:
			var reproducer: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
			reproducer.name = sound_name + str(index)
			reproducer.bus = bus
			reproducer.max_distance = MAX_DISTANCE
			reproducer.panning_strength = PANNING_STRENGTH
			reproducer.stream = stream
			add_child(reproducer)
			reproducers_by_name[sound_name].append(reproducer)

func play(sound_name: StringName, start_position: Vector2 = Vector2.ZERO) -> void:
	var reproducer: AudioStreamPlayer2D = find_available_reproducer(sound_name)

	if !reproducer:
		push_error(NO_AVAILABLE_REPRODUCER_ERROR + sound_name)
		return

	reproducer.position = Vector2.ZERO
	reproducer.pitch_scale = 1.0 + randf_range(-pitch_variation, pitch_variation)

	if start_position:
		reproducer.global_position = start_position

	reproducer.play()

func stop(sound_name: StringName) -> void:
	for reproducer: AudioStreamPlayer2D in reproducers_by_name.get(sound_name, []):
		reproducer.stop()

func find_available_reproducer(sound_name: StringName) -> AudioStreamPlayer2D:
	var oldest: AudioStreamPlayer2D = null
	var longest_time: float = -1.0

	for reproducer: AudioStreamPlayer2D in reproducers_by_name.get(sound_name, []):
		if !reproducer.playing:
			return reproducer

		var playback_time: float = reproducer.get_playback_position()
		if playback_time > longest_time:
			longest_time = playback_time
			oldest = reproducer

	return oldest
