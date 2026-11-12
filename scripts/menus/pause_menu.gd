class_name PauseMenu
extends CanvasLayer

class Option:
	const RESUME: int = 0
	const RETRY: int = 1
	const QUIT: int = 2

@onready var dim: ColorRect = $Dim
@onready var panel: Panel = $Panel
@onready var soul_menu: SoulMenu = $Panel/SoulMenu

func _ready() -> void:
	dim.hide()
	panel.hide()
	soul_menu.option_confirmed.connect(on_option_confirmed)

func _unhandled_input(event: InputEvent) -> void:
	if !soul_menu.interactive:
		return

	if event.is_action_pressed(InputNames.Menu.PAUSE) or event.is_action_pressed(InputNames.Menu.BACK):
		get_viewport().set_input_as_handled()
		GameManager.resume()

func open() -> void:
	dim.show()
	HudFx.pop_in(panel)
	soul_menu.open(Option.RESUME)

func close() -> void:
	if !is_open():
		return

	soul_menu.close()
	dim.hide()
	HudFx.pop_out(panel)

func is_open() -> bool:
	return dim.visible

func on_option_confirmed(index: int) -> void:
	if index == Option.RESUME:
		GameManager.resume()
		return

	close()

	if index == Option.RETRY:
		GameManager.retry_level()
		return

	GameManager.open_main_menu()
