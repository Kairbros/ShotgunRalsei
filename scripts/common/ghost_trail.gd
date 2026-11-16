class_name GhostTrail

const NODE_NAME: StringName = &"GhostTrail"
const FADE_DURATION: float = 0.3
const START_COLOR: Color = Color(1.0, 0.45, 0.85, 0.75)
const END_COLOR: Color = Color(0.45, 0.3, 1.0, 0.0)

class Property:
	const MODULATE: NodePath = ^"modulate"

static func spawn(
	source: AnimatedSprite2D,
	behind: Node2D,
	start_color: Color = START_COLOR,
	end_color: Color = END_COLOR,
	duration: float = FADE_DURATION) -> void:

	var ghost: Sprite2D = Sprite2D.new()
	ghost.name = NODE_NAME
	ghost.texture = source.sprite_frames.get_frame_texture(source.animation, source.frame)
	ghost.offset = source.offset
	ghost.modulate = start_color
	EffectsLayer.add_behind(ghost, behind)
	ghost.global_transform = source.global_transform

	var fade_tween: Tween = ghost.create_tween()
	fade_tween.tween_property(ghost, Property.MODULATE, end_color, duration)
	fade_tween.tween_callback(ghost.queue_free)
