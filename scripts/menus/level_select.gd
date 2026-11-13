class_name LevelSelect
extends Control

const CARD_SCENE: PackedScene = preload("res://scenes/menus/level_card.tscn")
const CARD_GAP: float = 28.0

var cards: Array[LevelCard] = []

@onready var soul_menu: SoulMenu = $SoulMenu
@onready var card_row: Control = $SoulMenu/Cards

func _ready() -> void:
	build_cards()
	soul_menu.option_focused.connect(on_card_focused)
	soul_menu.option_confirmed.connect(on_card_confirmed)
	soul_menu.open(get_first_available_index())

func _unhandled_input(event: InputEvent) -> void:
	if soul_menu.can_interact() and event.is_action_pressed(InputNames.Menu.BACK):
		get_viewport().set_input_as_handled()
		soul_menu.close()
		GameManager.open_main_menu()

func build_cards() -> void:
	var levels: Array[LevelRegistry.Level] = LevelRegistry.get_levels()
	var options: Array[Control] = []

	for level: LevelRegistry.Level in levels:
		var card: LevelCard = CARD_SCENE.instantiate()
		card_row.add_child(card)
		card.setup(level)
		card.position.x = get_card_x(card, cards.size(), levels.size())
		cards.append(card)
		options.append(card)

		if card.is_locked():
			soul_menu.lock(card)

	soul_menu.set_options(options)

func get_card_x(card: LevelCard, index: int, count: int) -> float:
	var row_width: float = card.size.x * count + CARD_GAP * (count - 1)
	return floorf((card_row.size.x - row_width) / 2.0) + index * (card.size.x + CARD_GAP)

func get_first_available_index() -> int:
	return maxi(cards.find_custom(func(card: LevelCard) -> bool: return !card.is_locked()), 0)

func on_card_focused(index: int) -> void:
	for card: LevelCard in cards:
		card.set_highlighted(card == cards[index])

func on_card_confirmed(index: int) -> void:
	GameManager.open_level(cards[index].level)
