class_name DashPips
extends HBoxContainer

@export var full_texture: Texture2D
@export var empty_texture: Texture2D
@export var pip_material: ShaderMaterial

var pips: Array[CooldownIcon] = []
var charges: int = 0

func set_charges(
	new_charges: int,
	max_charges: int,
	recharge_ratio: float,
	recharge_duration: float) -> void:

	build_pips(max_charges)

	for index: int in pips.size():
		var pip: CooldownIcon = pips[index]

		if index < new_charges:
			pip.set_ready(index >= charges)

		elif index == new_charges:
			pip.start_recharge(recharge_ratio, recharge_duration * (1.0 - recharge_ratio))

		else:
			pip.set_empty()

	charges = new_charges

func build_pips(max_charges: int) -> void:
	if pips.size() == max_charges:
		return

	for pip: CooldownIcon in pips:
		pip.queue_free()

	pips.clear()

	for index: int in max_charges:
		var pip: CooldownIcon = CooldownIcon.new()
		pip.texture_under = empty_texture
		pip.texture_progress = full_texture
		pip.material = pip_material.duplicate()
		add_child(pip)
		pips.append(pip)

	charges = max_charges

func get_ready_count() -> int:
	return pips.filter(func(pip: CooldownIcon) -> bool: return pip.is_ready()).size()
