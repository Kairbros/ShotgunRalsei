class_name MainMenu
extends Control

class Option:
	const PLAY: int = 0
	const QUIT: int = 1

@onready var soul_menu: SoulMenu = $SoulMenu

func _ready() -> void:
	soul_menu.option_confirmed.connect(on_option_confirmed)
	soul_menu.open(Option.PLAY)

func on_option_confirmed(index: int) -> void:
	if index == Option.PLAY:
		GameManager.open_level_select()
		return

	GameManager.quit_game()
