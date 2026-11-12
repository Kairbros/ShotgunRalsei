class_name ShieldIndicator
extends Control

const BUFF_FORMAT: String = "x%d"

@onready var icon: CooldownIcon = $Icon
@onready var buff_label: Label = $Buff

func _ready() -> void:
	buff_label.hide()

func set_cooldown(running: bool, recharge_ratio: float, time_left: float, announce: bool) -> void:
	if running:
		icon.start_recharge(recharge_ratio, time_left)
		return

	icon.set_ready(announce)

func set_buff(active: bool, duration: float, damage_multiplier: int) -> void:
	buff_label.visible = active
	buff_label.text = BUFF_FORMAT % damage_multiplier

	if !active:
		HudFx.stop_rainbow(icon)
		HudFx.stop_rainbow(buff_label)
		return

	HudFx.rainbow(icon, duration)
	HudFx.rainbow(buff_label, duration)
	VFX.flash(buff_label)
