class_name FallingCat
extends Minion

class State:
	const WARN: StringName = &"Warn"
	const FALL: StringName = &"Fall"
	const LAND: StringName = &"Land"

class Anim:
	const FALL: StringName = &"fall"

class Sound:
	const LAND: StringName = &"Land"

class Particle:
	const LAND: StringName = &"ParticleLand"

@export var drop_height: float = 300.0
@export var warning_duration: float = 0.75
@export var rest_duration: float = 0.3

@onready var warning: Node2D = $Warning

func _ready() -> void:
	super()
	state_machine.state_changed.connect(on_state_changed)

func spawn(summoner_position: Vector2, new_target: Player, floor_span: Vector2) -> void:
	super(summoner_position, new_target, floor_span)
	var landing: Vector2 = Vector2(
		roundf(clampf(target.global_position.x, floor_span.x, floor_span.y)), summoner_position.y)
	warning.global_position = landing
	global_position = landing + Vector2.UP * drop_height

func move(delta: float) -> void:
	handle_gravity(delta)
	move_and_slide()

func on_state_changed(new_state: StateBase) -> void:
	warning.visible = new_state.name in [State.WARN, State.FALL]
