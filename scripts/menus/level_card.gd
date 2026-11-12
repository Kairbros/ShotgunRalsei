class_name LevelCard
extends Panel

const LOCKED_ICON_TINT: Color = Color(0.25, 0.25, 0.25)
const LOCKED_TEXT_TINT: Color = Color(0.6, 0.6, 0.6)

var level: LevelRegistry.Level = null

@onready var icon: Sprite2D = $Icon
@onready var name_label: Label = $Name
@onready var status_label: Label = $Status

func setup(card_level: LevelRegistry.Level) -> void:
	level = card_level
	icon.texture = level.icon
	name_label.text = level.display_name
	status_label.visible = is_locked()

	if is_locked():
		icon.modulate = LOCKED_ICON_TINT
		name_label.modulate = LOCKED_TEXT_TINT

func is_locked() -> bool:
	return !level.is_available()

func set_highlighted(highlighted: bool) -> void:
	SoulCursor.paint(name_label, highlighted)
