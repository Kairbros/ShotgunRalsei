class_name EffectsLayer
extends Node2D

const GROUP: StringName = &"effects_layer"

func _enter_tree() -> void:
	add_to_group(GROUP)

static func add(effect: Node2D, near: Node2D) -> void:
	var layer: Node = near.get_tree().get_first_node_in_group(GROUP)

	if layer:
		layer.add_child(effect, true)
		return

	near.add_sibling(effect, true)

static func add_behind(effect: Node2D, near: Node2D) -> void:
	add(effect, near)

	if effect.get_parent() == near.get_parent():
		near.get_parent().move_child(effect, near.get_index())
