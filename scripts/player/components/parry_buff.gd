class_name ParryBuff
extends Countdown

@export var damage_multiplier: int = 5
@export var speed_multiplier: float = 1.5
@export var jump_multiplier: float = 1.2
@export var animation_speed: float = 1.5
@export var rainbow_cycles_per_second: float = 3.0
@export var rainbow_saturation: float = 0.6

@onready var player: Player = owner
@onready var base_speed_force: float = player.speed_force
@onready var base_jump_force: float = player.jump_force

func _ready() -> void:
	running_changed.connect(apply_stats)

func _physics_process(delta: float) -> void:
	super(delta)

	if is_running():
		player.animated_sprite.self_modulate = Color.from_hsv(
			fposmod(time_left * rainbow_cycles_per_second, 1.0), rainbow_saturation, 1.0)

func get_damage_multiplier() -> int:
	return damage_multiplier if is_running() else 1

func apply_stats(is_active: bool) -> void:
	player.speed_force = base_speed_force * (speed_multiplier if is_active else 1.0)
	player.jump_force = base_jump_force * (jump_multiplier if is_active else 1.0)
	player.animated_sprite.speed_scale = animation_speed if is_active else 1.0
	player.animated_sprite.self_modulate = Color.WHITE
	player.buff_glint.emitting = is_active
