class_name SoulCursor
extends Sprite2D

@onready var move_sound: AudioStreamPlayer = $MoveSound
@onready var select_sound: AudioStreamPlayer = $SelectSound

func move_to(target_position: Vector2, audible: bool) -> void:
	position = target_position.round()
	VFX.squash(self)

	if audible:
		move_sound.play()

func confirm(option: CanvasItem) -> void:
	VFX.flash(self)
	HudFx.bright_flash(option)
	select_sound.play()

static func paint(option: CanvasItem, highlighted: bool) -> void:
	option.self_modulate = HudPalette.YELLOW if highlighted else HudPalette.WHITE
