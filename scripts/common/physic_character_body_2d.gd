class_name PhysicCharacterBody2D
extends CharacterBody2D

const GRAVITY_FORCE: float = 1800.0
const MAX_VERTICAL_VELOCITY: float = GRAVITY_FORCE * 0.425

class Acceleration:
	const HIGH: float = 6.5
	const MEDIUM: float = 4.0
	const LOW: float = 1.5

signal health_changed(health: int, max_health: int)
signal facing_changed(facing: float)

@export_group("Stats")
@export var max_health: int = 100
@export var damage_amount: int = 10
@export var weight: float = 1.0
@export var knockback_potency: float = 150.0

@export_group("Movement")
@export var speed_force: float = 180.0
@export var jump_force: float = -330.0

@onready var health: int = max_health
@onready var graphics: Node2D = $Graphics
@onready var animated_sprite: AnimatedSprite2D = $Graphics/AnimatedSprite
@onready var state_machine: StateMachine = $StateMachine
@onready var hurtbox: Hurtbox = $Hurtbox
@onready var hurtbox_collider: CollisionShape2D = $Hurtbox/HurtboxCollider
@onready var multi_sound_2d: MultiSound2D = $MultiSound2D
@onready var multi_particle_2d: MultiParticle2D = $MultiParticle2D

func _ready() -> void:
	hurtbox.was_hit.connect(take_damage)

func take_damage(
	damage: int,
	_damage_origin: Vector2 = Vector2.ZERO,
	_knockback_force: float = 0.0) -> void:

	update_health(-absi(damage))

func update_health(health_amount: int) -> void:
	health = clampi(health + health_amount, 0, max_health)
	health_changed.emit(health, max_health)

func is_alive() -> bool:
	return health > 0

func set_vulnerable(enabled: bool) -> void:
	hurtbox_collider.set_disabled.call_deferred(!enabled)

func stun(_duration: float) -> void:
	pass

func apply_knockback(damage_origin: Vector2, knockback_force: float, lift_force: float) -> void:
	var direction: float = signf(global_position.x - damage_origin.x)

	if !direction:
		direction = -get_facing()

	velocity = Vector2(direction * knockback_force, lift_force) / weight

func get_move_axis() -> float:
	return signf(Input.get_axis(InputNames.Move.LEFT, InputNames.Move.RIGHT))

func handle_movement(
	acceleration: float,
	direction: float = get_move_axis(),
	delta: float = get_physics_process_delta_time()) -> void:

	velocity.x = move_toward(velocity.x, direction * speed_force, acceleration * delta)

func handle_friction(acceleration: float) -> void:
	handle_movement(absf(velocity.x) * acceleration, 0.0)

func handle_gravity(delta: float = get_physics_process_delta_time()) -> void:
	if !is_on_floor():
		velocity.y = clampf(
			velocity.y + GRAVITY_FORCE * delta,
			-GRAVITY_FORCE,
			MAX_VERTICAL_VELOCITY)

func get_facing() -> float:
	return graphics.transform.x.x

func handle_rotation(direction: float = get_facing()) -> void:
	if direction != 0 and direction != get_facing():
		VFX.squash(animated_sprite)
		graphics.transform.x.x = direction
		facing_changed.emit(direction)
