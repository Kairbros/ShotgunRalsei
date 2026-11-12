class_name TasquePhase
extends Resource

@export_range(0.0, 1.0) var starts_at: float = 1.0
@export var attacks: Array[PackedScene] = []
@export var interval_start: float = 1.3
@export var interval_end: float = 0.9
@export var opening_delay: float = 1.2
@export var voice: StringName = &""
