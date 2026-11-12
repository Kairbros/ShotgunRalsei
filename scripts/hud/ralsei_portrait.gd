class_name RalseiPortrait
extends Control

signal spoke(line: String)

const DEAD_FADE_DURATION: float = 0.6

const HURT_LINES: Array[String] = ["* ¡Eso dolió!", "* ¡¡OYE!!", "* ¡Hey!", "* ¡Auch!"]
const HEAL_LINES: Array[String] = ["* ¡Mucho mejor!", "* ¡Me siento genial!"]
const PARRY_LINES: Array[String] = ["* ¡Ja!", "* ¡Bloqueado!", "* ¡Toma esa!"]
const DEATH_LINES: Array[String] = ["* Lo siento..."]

class Face:
	const NEUTRAL: StringName = &"neutral"
	const SHOOT: StringName = &"shoot"
	const HURT: StringName = &"hurt"
	const DEAD: StringName = &"dead"

class Duration:
	const HURT: float = 0.8
	const HEAL: float = 1.0
	const PARRY: float = 1.0
	const PERMANENT: float = 0.0

class Priority:
	const NONE: int = 0
	const HEAL: int = 1
	const PARRY: int = 2
	const HURT: int = 3
	const DEATH: int = 4

class Reaction:
	var face: StringName
	var lines: Array[String]
	var priority: int
	var duration: float

	func _init(
		reaction_face: StringName,
		reaction_lines: Array[String],
		reaction_priority: int,
		reaction_duration: float) -> void:

		face = reaction_face
		lines = reaction_lines
		priority = reaction_priority
		duration = reaction_duration

	func is_permanent() -> bool:
		return duration <= Duration.PERMANENT

var hurt_reaction: Reaction = Reaction.new(Face.HURT, HURT_LINES, Priority.HURT, Duration.HURT)
var heal_reaction: Reaction = Reaction.new(Face.NEUTRAL, HEAL_LINES, Priority.HEAL, Duration.HEAL)
var parry_reaction: Reaction = Reaction.new(Face.SHOOT, PARRY_LINES, Priority.PARRY, Duration.PARRY)
var death_reaction:    = Reaction.new(
	Face.DEAD, DEATH_LINES, Priority.DEATH, Duration.PERMANENT)

var base_face: StringName = Face.NEUTRAL
var active_priority: int = Priority.NONE
var reaction_tween: Tween = null

@onready var sprite: AnimatedSprite2D = $Sprite

func set_facing(facing: float) -> void:
	sprite.flip_h = facing > 0.0

func set_shooting(shooting: bool) -> void:
	set_base_face(Face.SHOOT if shooting else Face.NEUTRAL)

func set_buffed(active: bool, duration: float) -> void:
	if active:
		HudFx.rainbow(sprite, duration)
		return

	HudFx.stop_rainbow(sprite)

func react_hurt() -> void:
	react(hurt_reaction)

func react_heal() -> void:
	react(heal_reaction)

func react_parry() -> void:
	react(parry_reaction)

func react_death() -> void:
	react(death_reaction)
	HudFx.stop_rainbow(sprite)
	reaction_tween = create_tween()
	reaction_tween.tween_property(
		self, HudFx.Property.MODULATE, HudPalette.DEAD_TINT, DEAD_FADE_DURATION)

func react(reaction: Reaction) -> void:
	if reaction.priority < active_priority:
		return

	if reaction_tween:
		reaction_tween.kill()

	active_priority = reaction.priority
	sprite.play(reaction.face)
	HudFx.bright_flash(sprite)
	spoke.emit(reaction.lines.pick_random())

	if reaction.is_permanent():
		return

	reaction_tween = create_tween()
	reaction_tween.tween_interval(reaction.duration)
	reaction_tween.tween_callback(end_reaction)

func end_reaction() -> void:
	active_priority = Priority.NONE
	sprite.play(base_face)

func set_base_face(face: StringName) -> void:
	base_face = face

	if active_priority == Priority.NONE:
		sprite.play(base_face)

func reset() -> void:
	if reaction_tween:
		reaction_tween.kill()

	active_priority = Priority.NONE
	modulate = HudPalette.WHITE
	HudFx.stop_rainbow(sprite)
	set_base_face(Face.NEUTRAL)

func get_face() -> StringName:
	return sprite.animation
