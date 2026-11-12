class_name Entity
extends Enemy

class State:
	const IDLE: StringName = &"Idle"
	const CHASE: StringName = &"Chase"
	const HURT: StringName = &"Hurt"
	const STUNNED: StringName = &"Stunned"
	const DEAD: StringName = &"Dead"

class Anim:
	const IDLE: StringName = &"idle"
	const WALK: StringName = &"walk"

class Particle:
	const POOF: StringName = &"ParticlePoof"

const BODY_CENTER: Vector2 = Vector2(0, -18)

@export_group("Movement")
@export var min_speed: float = 120.0
@export var max_speed: float = 160.0

@export_group("Behaviour")
@export var close_distance: float = 8.0
@export var hurt_duration: float = 0.35
@export var hurt_hop_force: float = -135.0
@export var hit_cooldown_duration: float = 1.2
@export var back_off_force: float = 120.0
@export var lost_target_duration: float = 0.4

var target: Player = null

@onready var particles: Node2D = $Graphics/Particles
@onready var player_detector: Area2D = $PlayerDetector
@onready var sight_ray: RayCast2D = $SightRay

func _ready() -> void:
	super()
	speed_force = randf_range(min_speed, max_speed)
	player_detector.body_entered.connect(on_player_detector_body_entered)
	player_detector.body_exited.connect(on_player_detector_body_exited)

func react_to_damage(_damage: int, damage_origin: Vector2, knockback_force: float) -> void:
	VFX.squash(animated_sprite)
	apply_knockback(damage_origin, knockback_force, hurt_hop_force)
	handle_rotation(-signf(velocity.x))

	if is_alive():
		enter_timed_state(State.HURT, hurt_duration)
	else:
		state_machine.change_state(State.DEAD)

func stun(duration: float) -> void:
	if is_alive():
		enter_timed_state(State.STUNNED, duration)

func dismiss() -> void:
	if !is_alive():
		return

	update_health(-health)
	state_machine.change_state(State.DEAD)

func can_see_target() -> bool:
	if !target or !target.is_alive():
		return false

	sight_ray.target_position = sight_ray.to_local(target.collider.global_position)
	sight_ray.force_raycast_update()
	return !sight_ray.is_colliding()

func is_target_close() -> bool:
	return absf(target.global_position.x - global_position.x) < close_distance

func get_target_direction() -> float:
	return signf(target.global_position.x - global_position.x)

func on_hit_landed(_hurtbox: Hurtbox) -> void:
	velocity.x = -get_facing() * back_off_force
	enter_timed_state(State.IDLE, hit_cooldown_duration)

func on_player_detector_body_entered(body: Node2D) -> void:
	if body is Player:
		target = body as Player

func on_player_detector_body_exited(body: Node2D) -> void:
	if body == target:
		target = null
