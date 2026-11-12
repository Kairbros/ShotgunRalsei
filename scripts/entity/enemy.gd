class_name Enemy
extends PhysicCharacterBody2D

signal died

const HIT_SOUND: StringName = &"Hit"

var state_timer: float = 0.0

@onready var hitbox: Hitbox = $Hitbox
@onready var hitbox_collider: CollisionShape2D = $Hitbox/HitboxCollider

func _ready() -> void:
	super()
	hitbox.setup_hitbox(damage_amount, knockback_potency)
	hitbox.hit_landed.connect(on_hit_landed)

func take_damage(
	damage: int,
	damage_origin: Vector2 = Vector2.ZERO,
	knockback_force: float = 0.0) -> void:

	if !is_alive():
		return

	super(damage, damage_origin, knockback_force)
	VFX.flash(animated_sprite)
	multi_sound_2d.play(HIT_SOUND)
	react_to_damage(damage, damage_origin, knockback_force)

	if !is_alive():
		died.emit()

func react_to_damage(_damage: int, _damage_origin: Vector2, _knockback_force: float) -> void:
	pass

func dismiss() -> void:
	pass

func enter_timed_state(state_name: StringName, duration: float) -> void:
	state_timer = duration
	state_machine.change_state(state_name)

func set_contact_damage(enabled: bool) -> void:
	hitbox_collider.set_disabled.call_deferred(!enabled)

func on_hit_landed(_hurtbox: Hurtbox) -> void:
	pass
