class_name SoulSelector
extends Control

signal option_confirmed(option: StringName)

class Option:
	const NONE: StringName = &""
	const CONTINUE: StringName = &"Continue"
	const QUIT: StringName = &"Quit"

@export var soul_speed: float = 224.0
@export var rail_half_length: float = 56.0
@export var select_distance: float = 36.0

var soul_offset: float = 0.0
var selected_option: StringName = Option.NONE
var interactive: bool = false

@onready var soul: SoulCursor = $Soul
@onready var soul_rest_x: float = soul.position.x
@onready var option_labels: Dictionary[StringName, Label] = {
	Option.CONTINUE: $Continue,
	Option.QUIT: $Quit,
}

func _ready() -> void:
	hide()

func _physics_process(delta: float) -> void:
	if !interactive:
		return

	var axis: float = signf(Input.get_axis(InputNames.Move.LEFT, InputNames.Move.RIGHT))
	soul_offset = clampf(
		soul_offset + axis * soul_speed * delta, -rail_half_length, rail_half_length)
	soul.position.x = soul_rest_x + roundf(soul_offset)
	select(get_option_at(soul_offset))

func _unhandled_input(event: InputEvent) -> void:
	if interactive and selected_option and event.is_action_pressed(InputNames.Menu.ACCEPT):
		confirm()

func open() -> void:
	HudFx.pop_in(self)
	interactive = true

func get_option_at(offset: float) -> StringName:
	if offset <= -select_distance:
		return Option.CONTINUE

	if offset >= select_distance:
		return Option.QUIT

	return Option.NONE

func select(option: StringName) -> void:
	if option == selected_option:
		return

	selected_option = option
	VFX.squash(soul)

	for label_option: StringName in option_labels:
		SoulCursor.paint(option_labels[label_option], label_option == selected_option)

func confirm() -> void:
	interactive = false
	soul.confirm(option_labels[selected_option])
	option_confirmed.emit(selected_option)
