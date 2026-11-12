class_name SoulMenu
extends Control

signal option_focused(index: int)
signal option_confirmed(index: int)

const LOCKED_SHAKE_MAGNITUDE: float = 2.0

@export var horizontal: bool = false
@export var soul_anchor: Vector2 = Vector2(0.0, 0.5)
@export var soul_offset: Vector2 = Vector2(-14.0, 0.0)
@export var options: Array[Control] = []

var locked_options: Array[Control] = []
var selected_index: int = 0
var interactive: bool = false

@onready var soul: SoulCursor = $Soul

func _ready() -> void:
	soul.hide()
	set_options(options)

func _process(_delta: float) -> void:
	if !interactive:
		return

	var step: int = get_step()

	if step != 0:
		select(wrapi(selected_index + step, 0, options.size()), true)
		return

	if Input.is_action_just_pressed(InputNames.Menu.ACCEPT):
		confirm()

func set_options(new_options: Array[Control]) -> void:
	options = new_options

	for index: int in options.size():
		var option: Control = options[index]
		option.mouse_filter = MOUSE_FILTER_STOP
		option.gui_input.connect(on_option_gui_input.bind(index))

func lock(option: Control) -> void:
	locked_options.append(option)

func open(index: int = selected_index) -> void:
	interactive = true
	soul.show()
	select(index, false)

func close() -> void:
	interactive = false

func get_step() -> int:
	if Input.is_action_just_pressed(InputNames.Move.LEFT if horizontal else InputNames.Menu.UP):
		return -1

	if Input.is_action_just_pressed(InputNames.Move.RIGHT if horizontal else InputNames.Menu.DOWN):
		return 1

	return 0

func select(index: int, audible: bool) -> void:
	selected_index = index
	var selected_option: Control = options[selected_index]

	for option: Control in options:
		SoulCursor.paint(option, option == selected_option)

	soul.move_to(get_soul_position(selected_option), audible)
	option_focused.emit(selected_index)

func get_soul_position(option: Control) -> Vector2:
	return option.global_position - global_position + option.size * soul_anchor + soul_offset

func confirm() -> void:
	var option: Control = options[selected_index]

	if option in locked_options:
		HudFx.shake(option, LOCKED_SHAKE_MAGNITUDE)
		return

	interactive = false
	soul.confirm(option)
	option_confirmed.emit(selected_index)

func on_option_gui_input(event: InputEvent, index: int) -> void:
	if !interactive or event is not InputEventMouse:
		return

	if index != selected_index:
		select(index, true)

	if is_left_click(event):
		confirm()

static func is_left_click(event: InputEvent) -> bool:
	var click: InputEventMouseButton = event as InputEventMouseButton
	return click != null and click.pressed and click.button_index == MOUSE_BUTTON_LEFT
