class_name GameOver
extends CanvasLayer

const LINES: Array[String] = [
	"* No te rindas... aun puedes\n  volver a intentarlo",
	"* Vamos...\n  intentalo una vez mas",
	"* Levantate...",
]
const TITLE_FADE_DURATION: float = 1.2
const MUSIC_FADE_IN_DURATION: float = 2.5
const MUSIC_VOLUME_DB: float = -6.0
const SILENT_VOLUME_DB: float = -40.0
const INTRO_SKIP_STEP: float = 60.0

class Anim:
	const SHATTER: StringName = &"shatter"

class Property:
	const VOLUME_DB: NodePath = ^"volume_db"

var line_index: int = 0
var intro_tween: Tween = null
var music_tween: Tween = null

@onready var heart: AnimatedSprite2D = $Screen/Heart
@onready var title: Label = $Screen/Title
@onready var soul_selector: SoulSelector = $Screen/SoulSelector
@onready var dialogue_box: DialogueBox = $Screen/DialogueBox
@onready var line_timer: Timer = $LineTimer
@onready var shatter_sound: AudioStreamPlayer = $ShatterSound
@onready var music: AudioStreamPlayer = $Music

func _ready() -> void:
	title.modulate = HudPalette.FADED
	soul_selector.option_confirmed.connect(on_option_confirmed)
	line_timer.timeout.connect(say_next_line)
	play_intro()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(InputNames.Menu.BACK) and intro_tween.is_running():
		intro_tween.custom_step(INTRO_SKIP_STEP)

func play_intro() -> void:
	heart.play(Anim.SHATTER)
	shatter_sound.play()

	intro_tween = create_tween()
	intro_tween.tween_interval(get_crack_duration())
	intro_tween.tween_callback(break_heart)
	intro_tween.tween_interval(SpriteShatter.MAX_LIFETIME)
	intro_tween.tween_callback(end_shatter)
	intro_tween.tween_property(title, HudFx.Property.MODULATE, HudPalette.WHITE, TITLE_FADE_DURATION)
	intro_tween.tween_callback(start_interaction)

func get_crack_duration() -> float:
	var frames: SpriteFrames = heart.sprite_frames
	var relative_time: float = 0.0

	for frame: int in frames.get_frame_count(Anim.SHATTER):
		relative_time += frames.get_frame_duration(Anim.SHATTER, frame)

	return relative_time / frames.get_animation_speed(Anim.SHATTER)

func break_heart() -> void:
	SpriteShatter.spawn(heart, heart, heart.global_position)
	heart.hide()

func end_shatter() -> void:
	shatter_sound.stop()
	fade_music(SILENT_VOLUME_DB, MUSIC_VOLUME_DB, MUSIC_FADE_IN_DURATION)
	music.play()

func start_interaction() -> void:
	soul_selector.open()
	HudFx.pop_in(dialogue_box)
	say_next_line()
	line_timer.start()

func say_next_line() -> void:
	dialogue_box.say(LINES[line_index])
	line_index = (line_index + 1) % LINES.size()

func fade_music(from_volume_db: float, to_volume_db: float, duration: float) -> void:
	if music_tween:
		music_tween.kill()

	music_tween = create_tween()
	music_tween.tween_property(music, Property.VOLUME_DB, to_volume_db, duration).from(
		from_volume_db)

func on_option_confirmed(option: StringName) -> void:
	line_timer.stop()
	dialogue_box.silence()
	fade_music(music.volume_db, SILENT_VOLUME_DB, Transition.COVER_DURATION)

	if option == SoulSelector.Option.CONTINUE:
		GameManager.retry_level()
		return

	GameManager.open_main_menu()
