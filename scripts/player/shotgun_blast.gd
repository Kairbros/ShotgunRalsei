class_name ShotgunBlast
extends Node2D

const ACTIVE_DURATION: float = 0.1

@onready var hitbox: Hitbox = $Hitbox
@onready var hitbox_collider: CollisionShape2D = $Hitbox/HitboxCollider
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite

func _ready() -> void:
	animated_sprite.animation_finished.connect(queue_free)
	animated_sprite.play()

	var active_tween: Tween = create_tween()
	active_tween.tween_interval(ACTIVE_DURATION)
	active_tween.tween_callback(hitbox_collider.set_disabled.bind(true))
