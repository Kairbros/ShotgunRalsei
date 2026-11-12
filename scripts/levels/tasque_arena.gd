class_name TasqueArena
extends Node2D

const SILENT_VOLUME_DB: float = -40.0

class Property:
	const COLOR: NodePath = ^"color"
	const MODULATE: NodePath = ^"modulate"
	const VOLUME: NodePath = ^"volume_db"

@export var camera_bounds: Rect2i = Rect2i(20, 0, 1120, 752)

@export_group("Lighting")
@export var ambient_light: Color = Color(0.78, 0.8, 0.92)
@export var blackout_light: Color = Color(0.03, 0.03, 0.06)
@export var fight_light: Color = Color(0.5, 0.52, 0.68)
@export var blackout_duration: float = 0.12
@export var fight_light_duration: float = 0.25
@export var restore_light_duration: float = 1.5

@export_group("Music")
@export var ambient_music: AudioStream
@export var boss_music: AudioStream
@export var music_volume_db: float = -10.0
@export var music_fade_duration: float = 1.2

var light_tween: Tween = null
var music_tween: Tween = null

@onready var player: Player = $Player
@onready var hud: Hud = $Hud
@onready var boss: TasqueManager = $TasqueManager
@onready var mood_light: CanvasModulate = $MoodLight
@onready var fight_backdrop: Node2D = $FightGrid
@onready var music: AudioStreamPlayer = $Music
@onready var victory_jingle: AudioStreamPlayer = $VictoryJingle
@onready var blackout_sound: AudioStreamPlayer = $BlackoutSound

func _ready() -> void:
	player.camera_player.set_limits(camera_bounds)
	fight_backdrop.modulate = Color.TRANSPARENT
	play_music(ambient_music)
	boss.awakened.connect(on_boss_awakened)
	boss.revealed.connect(on_boss_revealed)
	boss.died.connect(on_boss_died)
	boss.departed.connect(on_boss_departed)
	victory_jingle.finished.connect(play_music.bind(ambient_music))

func set_mood(light: Color, backdrop: Color, duration: float) -> void:
	if light_tween:
		light_tween.kill()

	light_tween = create_tween().set_parallel()
	light_tween.tween_property(mood_light, Property.COLOR, light, duration)
	light_tween.tween_property(fight_backdrop, Property.MODULATE, backdrop, duration)

func play_music(stream: AudioStream) -> void:
	stop_music_fade()
	music.stream = stream
	music.volume_db = music_volume_db
	music.play()

func fade_out_music() -> void:
	stop_music_fade()
	music_tween = create_tween()
	music_tween.tween_property(music, Property.VOLUME, SILENT_VOLUME_DB, music_fade_duration)
	music_tween.tween_callback(music.stop)

func stop_music_fade() -> void:
	if music_tween:
		music_tween.kill()

func on_boss_awakened() -> void:
	stop_music_fade()
	music.stop()
	blackout_sound.play()
	set_mood(blackout_light, Color.TRANSPARENT, blackout_duration)

func on_boss_revealed() -> void:
	set_mood(ambient_light, Color.WHITE, fight_light_duration)
	play_music(boss_music)
	hud.show_boss(boss, TasqueManager.DISPLAY_NAME, TasqueManager.BAR_COLOR)

func on_boss_died() -> void:
	fade_out_music()

func on_boss_departed() -> void:
	set_mood(ambient_light, Color.TRANSPARENT, restore_light_duration)
	victory_jingle.play()
