class_name StateMachine
extends Node

signal state_changed(new_state: StateBase)

@export var default_state: StateBase

var previous_state: StateBase = null
var current_state: StateBase = null

@onready var controlled_node: Node = owner

func _ready() -> void:
	assert(default_state, "Default state not found")

	change_state.call_deferred()

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.on_physics_process(delta)

func _unhandled_input(event: InputEvent) -> void:
	if current_state:
		current_state.on_unhandled_input(event)

func change_state(new_state_name: StringName = default_state.name) -> void:
	if current_state:
		previous_state = current_state
		previous_state.exit()

	current_state = get_node(NodePath(new_state_name))
	current_state.state_machine = self
	current_state.start()

	state_changed.emit(current_state)
