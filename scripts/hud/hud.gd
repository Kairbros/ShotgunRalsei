class_name Hud
extends CanvasLayer

const HURT_SHAKE_MAGNITUDE: float = 3.0

@export var player: Player

@onready var player_panel: Panel = $Screen/PlayerPanel
@onready var portrait: RalseiPortrait = $Screen/PlayerPanel/Portrait
@onready var health_gauge: HealthGauge = $Screen/PlayerPanel/HealthGauge
@onready var power_gauge: PowerGauge = $Screen/PlayerPanel/PowerGauge
@onready var dash_pips: DashPips = $Screen/PlayerPanel/DashPips
@onready var shield_indicator: ShieldIndicator = $Screen/PlayerPanel/ShieldIndicator
@onready var speech_box: SpeechBox = $Screen/SpeechBox
@onready var boss_bar: BossBar = $Screen/BossBar

func _ready() -> void:
	portrait.spoke.connect(speech_box.say)

	if player:
		bind_player(player)

func bind_player(new_player: Player) -> void:
	unbind_player()
	player = new_player

	var bindings: Dictionary[Signal, Callable] = get_player_bindings()
	for player_signal: Signal in bindings:
		player_signal.connect(bindings[player_signal])

	portrait.reset()
	portrait.set_facing(player.get_facing())
	health_gauge.set_health(player.health, player.max_health, true)
	power_gauge.set_power(player.power_meter.power, player.power_meter.max_power, true)
	on_dash_charges_changed(player.dash_charges.charges, player.dash_charges.max_charges)
	update_shield_cooldown(player.shield_cooldown.is_running(), false)

func unbind_player() -> void:
	if !is_instance_valid(player):
		return

	var bindings: Dictionary[Signal, Callable] = get_player_bindings()
	for player_signal: Signal in bindings:
		if player_signal.is_connected(bindings[player_signal]):
			player_signal.disconnect(bindings[player_signal])

func get_player_bindings() -> Dictionary[Signal, Callable]:
	return {
		player.health_changed: on_health_changed,
		player.hurt: on_hurt,
		player.healed: on_healed,
		player.died: portrait.react_death,
		player.facing_changed: portrait.set_facing,
		player.state_machine.state_changed: on_player_state_changed,
		player.power_meter.power_changed: power_gauge.set_power,
		player.dash_charges.charges_changed: on_dash_charges_changed,
		player.shield_cooldown.running_changed: on_shield_cooldown_changed,
		player.parry_buff.running_changed: on_parry_buff_changed,
	}

func show_boss(
	boss: PhysicCharacterBody2D,
	display_name: String,
	bar_color: Color = BossBar.DEFAULT_COLOR) -> void:

	boss_bar.show_boss(boss, display_name, bar_color)

func hide_boss() -> void:
	boss_bar.hide_boss()

func on_health_changed(health: int, max_health: int) -> void:
	health_gauge.set_health(health, max_health)

func on_hurt(_damage: int) -> void:
	HudFx.shake(player_panel, HURT_SHAKE_MAGNITUDE)
	health_gauge.flash()
	portrait.react_hurt()

func on_healed(_amount: int) -> void:
	health_gauge.flash()
	portrait.react_heal()

func on_player_state_changed(new_state: StateBase) -> void:
	portrait.set_shooting(new_state.name == Player.State.SHOOT)

func on_dash_charges_changed(charges: int, max_charges: int) -> void:
	var dash_charges: DashCharges = player.dash_charges
	dash_pips.set_charges(
		charges,
		max_charges,
		dash_charges.recharge_timer / dash_charges.recharge_duration,
		dash_charges.recharge_duration)

func on_shield_cooldown_changed(running: bool) -> void:
	update_shield_cooldown(running, true)

func update_shield_cooldown(running: bool, announce: bool) -> void:
	var cooldown: Countdown = player.shield_cooldown
	shield_indicator.set_cooldown(
		running, 1.0 - cooldown.time_left / cooldown.duration, cooldown.time_left, announce)

func on_parry_buff_changed(active: bool) -> void:
	var parry_buff: ParryBuff = player.parry_buff
	shield_indicator.set_buff(active, parry_buff.duration, parry_buff.damage_multiplier)
	portrait.set_buffed(active, parry_buff.duration)

	if active:
		portrait.react_parry()
