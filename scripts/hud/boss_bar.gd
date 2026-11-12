class_name BossBar
extends Panel

const NAME_FORMAT: String = "* %s"
const DEFAULT_COLOR: Color = HudPalette.YELLOW
const HIT_SHAKE_MAGNITUDE: float = 1.0
const DEFEAT_HOLD_DURATION: float = 0.8

var boss: PhysicCharacterBody2D = null
var defeat_tween: Tween = null

@onready var name_label: Label = $Name
@onready var gauge: HealthGauge = $Gauge

func _ready() -> void:
	hide()

func show_boss(
	new_boss: PhysicCharacterBody2D,
	display_name: String,
	bar_color: Color = DEFAULT_COLOR) -> void:

	unbind_boss()
	boss = new_boss
	name_label.text = NAME_FORMAT % display_name
	gauge.bar.set_fill_color(bar_color)
	gauge.set_health(boss.health, boss.max_health, true)
	boss.health_changed.connect(on_boss_health_changed)
	boss.tree_exiting.connect(hide_boss)
	HudFx.pop_in(self)

func hide_boss() -> void:
	unbind_boss()
	HudFx.pop_out(self)

func unbind_boss() -> void:
	if defeat_tween:
		defeat_tween.kill()
		defeat_tween = null

	if !is_instance_valid(boss):
		boss = null
		return

	boss.health_changed.disconnect(on_boss_health_changed)
	boss.tree_exiting.disconnect(hide_boss)
	boss = null

func has_boss() -> bool:
	return boss != null

func on_boss_health_changed(health: int, max_health: int) -> void:
	var damaged: bool = health < gauge.bar.value
	gauge.set_health(health, max_health)

	if damaged:
		gauge.flash()
		HudFx.shake(self, HIT_SHAKE_MAGNITUDE)

	if health > 0:
		return

	unbind_boss()
	defeat_tween = create_tween()
	defeat_tween.tween_interval(DEFEAT_HOLD_DURATION)
	defeat_tween.tween_callback(HudFx.pop_out.bind(self))
