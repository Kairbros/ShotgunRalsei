class_name Hitbox
extends Area2D

signal hit_landed(hurtbox: Hurtbox)

var damage_amount: int = 1
var knockback_potency: float = 150.0

func _ready() -> void:
	area_entered.connect(on_area_entered)

func setup_hitbox(damage: int, knockback: float) -> void:
	damage_amount = damage
	knockback_potency = knockback

func on_area_entered(area: Area2D) -> void:
	if area is Hurtbox:
		area.hit(damage_amount, global_position, knockback_potency)
		hit_landed.emit(area)
