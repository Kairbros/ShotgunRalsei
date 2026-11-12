class_name DialogueBox
extends Panel

@onready var text_label: Label = $Text
@onready var voice: AudioStreamPlayer = $Voice

func _ready() -> void:
	hide()

func say(line: String) -> void:
	HudFx.type_text(text_label, voice, line)

func silence() -> void:
	voice.stop()
