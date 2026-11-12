class_name Hurtbox
extends Area2D

signal was_hit(damage_amount: int, damage_origin: Vector2, knockback_potency: float)

func hit(damage_amount: int, damage_origin: Vector2, knockback_potency: float) -> void:
	was_hit.emit(damage_amount, damage_origin, knockback_potency)
