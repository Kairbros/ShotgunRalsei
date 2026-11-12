class_name SpeechBox
extends Panel

const HOLD_DURATION: float = 1.2

class ThemeName:
	const FONT: StringName = &"font"
	const FONT_SIZE: StringName = &"font_size"

@onready var text_label: Label = $Text
@onready var voice: AudioStreamPlayer = $Voice

func _ready() -> void:
	hide()

func say(line: String) -> void:
	size.x = get_text_width(line) + floori(text_label.position.x) * 2
	HudFx.pop_in(self)

	var speech_tween: Tween = HudFx.type_text(text_label, voice, line)
	speech_tween.tween_interval(HOLD_DURATION)
	speech_tween.tween_callback(HudFx.pop_out.bind(self))

func get_text_width(line: String) -> int:
	var font: Font = text_label.get_theme_font(ThemeName.FONT)
	var font_size: int = text_label.get_theme_font_size(ThemeName.FONT_SIZE)
	return ceili(font.get_string_size(line, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size).x)
