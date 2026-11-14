class_name TasqueManager
extends Enemy

signal awakened
signal revealed
signal departed

const DISPLAY_NAME: String = "Tasque Manager"
const BAR_COLOR: Color = Color("7effff")
const AFTERIMAGE_COLOR: Color = Color(0.5, 1.0, 1.0, 0.6)
const AFTERIMAGE_FADED: Color = Color(0.2, 0.6, 1.0, 0.0)
const AFTERIMAGE_DURATION: float = 0.3

class State:
	const DORMANT: StringName = &"Dormant"
	const INTRO: StringName = &"Intro"
	const ATTACK: StringName = &"Attack"
	const REPOSITION: StringName = &"Reposition"
	const DASH_WIND_UP: StringName = &"DashWindUp"
	const DASH: StringName = &"Dash"
	const DEFEATED: StringName = &"Defeated"

class Anim:
	const IDLE: StringName = &"idle"
	const DASH: StringName = &"dash"

class Voice:
	const LAUGH: StringName = &"TasqueLaugh"
	const CLICK: StringName = &"SpotlightClick"
	const DASH: StringName = &"TasqueVoiceD"
	const SPARE: StringName = &"TasqueSpare"

class Particle:
	const DASH: StringName = &"ParticleDash"
	const LAND: StringName = &"ParticleLand"

class Property:
	const MODULATE: NodePath = ^"modulate"

@export var phases: Array[TasquePhase] = []
@export var floor_span: Vector2 = Vector2(60.0, 1080.0)

@export_group("Intro")
@export var blackout_duration: float = 1.6
@export var laugh_duration: float = 1.4
@export var reveal_duration: float = 1.0

@export_group("Reposition")
@export var reposition_interval: Vector2 = Vector2(4.0, 7.0)
@export var reposition_speed: float = 120.0
@export var reposition_min_distance: float = 120.0
@export var reposition_player_clearance: float = 90.0
@export var reposition_edge_margin: float = 80.0
@export var reposition_attempts: int = 8

@export_group("Dash")
@export var dash_damage_threshold: int = 40
@export var dash_wind_up_duration: float = 0.5
@export var dash_duration: float = 0.9
@export var dash_speed: float = 360.0
@export var dash_contact_damage: int = 25
@export var dash_min_room: float = 200.0
@export var dash_shake_magnitude: float = 3.0
@export var afterimage_interval: float = 0.05

@export_group("Reinforcements")
@export var dog_scene: PackedScene
@export var max_dogs: int = 2

@export_group("Defeat")
@export var spare_duration: float = 1.5

var target: Player = null
var phase_index: int = -1
var damage_since_dash: int = 0
var attack_bag: Array[PackedScene] = []

@onready var parts: Node2D = $Graphics/AnimatedSprite/Parts
@onready var player_detector: Area2D = $PlayerDetector
@onready var minions: Node2D = $Minions

func react_to_damage(damage: int, _damage_origin: Vector2, _knockback_force: float) -> void:
	if is_alive():
		damage_since_dash += damage
	else:
		state_machine.change_state(State.DEFEATED)

func awaken(new_target: Player) -> void:
	target = new_target
	awakened.emit()

func reveal() -> void:
	graphics.show()
	face_target()
	set_vulnerable(true)
	set_contact_damage(true)
	VFX.flash(animated_sprite)
	multi_sound_2d.play(Voice.CLICK)
	revealed.emit()

func burst() -> void:
	VFX.stop_blink(animated_sprite)
	set_dash_pose(true)
	explode(&"")
	departed.emit()

func face_target() -> void:
	handle_rotation(signf(target.global_position.x - global_position.x))

func get_health_ratio() -> float:
	return float(health) / float(max_health)

func get_phase() -> TasquePhase:
	return phases[phase_index]

func update_phase() -> bool:
	var next_index: int = phase_index

	while next_index + 1 < phases.size() and get_health_ratio() <= phases[next_index + 1].starts_at:
		next_index += 1

	if next_index == phase_index:
		return false

	phase_index = next_index
	attack_bag.clear()
	multi_sound_2d.play(get_phase().voice)
	return true

func get_spawn_interval() -> float:
	var phase: TasquePhase = get_phase()
	var ends_at: float = phases[phase_index + 1].starts_at if phase_index + 1 < phases.size() else 0.0
	var progress: float = clampf(inverse_lerp(phase.starts_at, ends_at, get_health_ratio()), 0.0, 1.0)
	return lerpf(phase.interval_start, phase.interval_end, progress)

func summon() -> void:
	var minion: Minion = draw_attack().instantiate()
	minions.add_child(minion)
	minion.spawn(global_position, target, floor_span)

func draw_attack() -> PackedScene:
	if attack_bag.is_empty():
		attack_bag = get_phase().attacks.duplicate()
		attack_bag.shuffle()

	return attack_bag.pop_back()

func call_reinforcement() -> void:
	if minions.get_children().filter(is_dog).size() >= max_dogs:
		return

	var dog: Entity = dog_scene.instantiate()
	minions.add_child(dog)
	dog.global_position = global_position

func is_dog(node: Node) -> bool:
	return node is Entity

func clear_minions() -> void:
	for minion: Node in minions.get_children():
		if minion is Enemy:
			(minion as Enemy).dismiss()

func wants_dash() -> bool:
	return damage_since_dash >= dash_damage_threshold

func pick_reposition_delay() -> float:
	return randf_range(reposition_interval.x, reposition_interval.y)

func pick_reposition_x() -> float:
	for attempt: int in reposition_attempts:
		var candidate: float = randf_range(
			floor_span.x + reposition_edge_margin, floor_span.y - reposition_edge_margin)
		if is_fair_reposition(candidate):
			return candidate

	return global_position.x

func is_fair_reposition(candidate: float) -> bool:
	var target_x: float = target.global_position.x
	return (absf(candidate - global_position.x) >= reposition_min_distance
		and absf(candidate - target_x) >= reposition_player_clearance
		and signf(candidate - target_x) == signf(global_position.x - target_x))

func pick_dash_direction() -> float:
	var direction: float = [-1.0, 1.0].pick_random()
	var wall_x: float = floor_span.y if direction > 0.0 else floor_span.x

	if absf(wall_x - global_position.x) < dash_min_room:
		direction = -direction

	return direction

func set_dash_pose(enabled: bool) -> void:
	animated_sprite.play(Anim.DASH if enabled else Anim.IDLE)
	parts.visible = !enabled

func set_contact_damage_amount(amount: int) -> void:
	hitbox.setup_hitbox(amount, knockback_potency)

func shake_screen() -> void:
	target.shake_camera(dash_shake_magnitude)

func spawn_afterimage() -> void:
	var afterimage: Sprite2D = GhostTrail.create_ghost(animated_sprite)
	afterimage.modulate = AFTERIMAGE_COLOR
	add_sibling(afterimage, true)
	get_parent().move_child(afterimage, get_index())
	afterimage.global_transform = animated_sprite.global_transform
	var fade_tween: Tween = afterimage.create_tween()
	fade_tween.tween_property(afterimage, Property.MODULATE, AFTERIMAGE_FADED, AFTERIMAGE_DURATION)
	fade_tween.tween_callback(afterimage.queue_free)
