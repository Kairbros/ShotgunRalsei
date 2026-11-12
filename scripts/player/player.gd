class_name Player
extends PhysicCharacterBody2D

signal died
signal hurt(damage: int)
signal healed(amount: int)

const JUMP_DURATION: float = 0.15
const JUMP_HOLD_FORCE: float = -1700.0
const BODY_CENTER: Vector2 = Vector2(0, -20)
const CAMERA_SHAKE_DURATION: float = 0.3

class Anim:
	const IDLE: StringName = &"idle"
	const WALK: StringName = &"walk"
	const JUMP: StringName = &"jump"
	const SHOOT: StringName = &"shoot"
	const DASH: StringName = &"dash"
	const SHIELD: StringName = &"shield"
	const POWER: StringName = &"power"
	const HURT: StringName = &"hurt"
	const DEAD: StringName = &"dead"
	const TAUNT: StringName = &"taunt"

class State:
	const IDLE: StringName = &"Idle"
	const WALK: StringName = &"Walk"
	const JUMP: StringName = &"Jump"
	const FALL: StringName = &"Fall"
	const SHOOT: StringName = &"Shoot"
	const DASH: StringName = &"Dash"
	const SHIELD: StringName = &"Shield"
	const POWER: StringName = &"Power"
	const HURT: StringName = &"Hurt"
	const DEAD: StringName = &"Dead"
	const TAUNT: StringName = &"Taunt"

class Sound:
	const STEP: StringName = &"Step"
	const JUMP: StringName = &"Jump"
	const LAND: StringName = &"Land"
	const SHOTGUN: StringName = &"Shotgun"
	const DASH: StringName = &"Dash"
	const PARRY: StringName = &"Parry"
	const HEAL: StringName = &"Heal"
	const HURT: StringName = &"Hurt"

class Particle:
	const STEP: StringName = &"ParticleStep"
	const JUMP: StringName = &"ParticleJump"
	const LAND: StringName = &"ParticleLand"
	const MUZZLE: StringName = &"ParticleMuzzle"
	const SHELL: StringName = &"ParticleShell"
	const HIT: StringName = &"ParticleHit"
	const PARRY: StringName = &"ParticleParry"
	const CHARGE: StringName = &"ParticleCharge"
	const HEAL: StringName = &"ParticleHeal"
	const DASH: StringName = &"ParticleDash"

class ShakeMagnitude:
	const SHOOT: float = 2.0
	const HIT_TARGET: float = 1.0
	const DASH: float = 1.0
	const PARRY: float = 3.0
	const POWER: float = 2.0
	const HURT: float = 3.25
	const DEAD: float = 4.0

var coyote_time: GameFeeling.CoyoteTime = GameFeeling.CoyoteTime.new()
var input_buffer: GameFeeling.InputBuffer = GameFeeling.InputBuffer.new()

@onready var muzzle: Marker2D = $Graphics/Muzzle
@onready var shell_ejector: Marker2D = $Graphics/ShellEjector
@onready var parry_area: Area2D = $Graphics/ParryArea
@onready var parry_area_collider: CollisionShape2D = $Graphics/ParryArea/ParryAreaCollider
@onready var collider: CollisionShape2D = $Collider
@onready var camera_player: CameraPlayer = $CameraPlayer
@onready var power_meter: PowerMeter = $PowerMeter
@onready var dash_charges: DashCharges = $DashCharges
@onready var shield_cooldown: Countdown = $ShieldCooldown
@onready var hurt_invulnerability: Countdown = $HurtInvulnerability
@onready var parry_buff: ParryBuff = $ParryBuff
@onready var buff_glint: CPUParticles2D = $BuffGlint

func _physics_process(_delta: float) -> void:
	var vulnerable: bool = !is_invulnerable()

	if hurtbox_collider.disabled == vulnerable:
		set_vulnerable(vulnerable)

func handle_rotation(direction: float = get_move_axis()) -> void:
	super(direction)

func get_resting_state() -> StringName:
	return State.IDLE if is_on_floor() else State.FALL

func play_feedback(
	sound_name: StringName,
	particle_name: StringName,
	at_position: Vector2 = global_position) -> void:

	multi_sound_2d.play(sound_name)
	multi_particle_2d.emit(particle_name, at_position, get_facing())

func shake_camera(magnitude: float) -> void:
	camera_player.camera_shake(CAMERA_SHAKE_DURATION, magnitude)

func take_damage(
	damage: int,
	damage_origin: Vector2 = Vector2.ZERO,
	knockback_force: float = 0.0) -> void:

	if is_invulnerable() or !is_alive():
		return

	super(damage, damage_origin, knockback_force)
	hurt.emit(absi(damage))
	apply_knockback(damage_origin, knockback_force, -knockback_force)
	state_machine.change_state(State.HURT if is_alive() else State.DEAD)

func heal(amount: int) -> void:
	update_health(amount)
	healed.emit(amount)
	play_feedback(Sound.HEAL, Particle.HEAL, global_position + BODY_CENTER)

func is_invulnerable() -> bool:
	var current_state: PlayerStateBase = state_machine.current_state as PlayerStateBase

	return (hurt_invulnerability.is_running()
		or parry_buff.is_running()
		or (current_state != null and current_state.invulnerable))
