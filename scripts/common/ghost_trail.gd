class_name GhostTrail

const NODE_NAME: StringName = &"GhostTrail"
const FADE_DURATION: float = 0.3
const START_COLOR: Color = Color(1.0, 0.45, 0.85, 0.75)
const END_COLOR: Color = Color(0.45, 0.3, 1.0, 0.0)

class Property:
	const MODULATE: NodePath = ^"modulate"

static func spawn(source: AnimatedSprite2D, behind: Node2D) -> void:
	var ghost: Sprite2D = create_ghost(source)
	behind.add_sibling(ghost, true)
	behind.get_parent().move_child(ghost, behind.get_index())
	ghost.global_transform = source.global_transform
	fade_out(ghost)

static func create_ghost(source: AnimatedSprite2D) -> Sprite2D:
	var ghost: Sprite2D = Sprite2D.new()
	ghost.name = NODE_NAME
	ghost.texture = source.sprite_frames.get_frame_texture(source.animation, source.frame)
	ghost.offset = source.offset
	ghost.modulate = START_COLOR
	return ghost

static func fade_out(ghost: Sprite2D) -> void:
	var fade_tween: Tween = ghost.create_tween()
	fade_tween.tween_property(ghost, Property.MODULATE, END_COLOR, FADE_DURATION)
	fade_tween.tween_callback(ghost.queue_free)
