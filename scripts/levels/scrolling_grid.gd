class_name ScrollingGrid
extends Sprite2D

@export var scroll_velocity: Vector2 = Vector2(-12.0, -12.0)

var scroll: Vector2 = Vector2.ZERO

func _process(delta: float) -> void:
	scroll = (scroll + scroll_velocity * delta).posmod(texture.get_width())
	region_rect.position = scroll.round()
