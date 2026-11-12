class_name Transition
extends CanvasLayer

const COVER_DURATION: float = 0.4
const REVEAL_DURATION: float = 0.3

class Property:
	const COVER_OPACITY: NodePath = ^"color:a"

var scene_path: String = ""

@onready var cover: ColorRect = $Cover

func cover_to(target_scene_path: String) -> void:
	scene_path = target_scene_path
	cover_then(swap_scene)

func cover_then(on_covered: Callable) -> void:
	var cover_tween: Tween = create_tween()
	cover_tween.tween_property(cover, Property.COVER_OPACITY, 1.0, COVER_DURATION)
	cover_tween.tween_callback(on_covered)

func swap_scene() -> void:
	get_tree().scene_changed.connect(reveal, CONNECT_ONE_SHOT)
	get_tree().change_scene_to_file(scene_path)

func reveal() -> void:
	var reveal_tween: Tween = create_tween()
	reveal_tween.tween_property(cover, Property.COVER_OPACITY, 0.0, REVEAL_DURATION)
	reveal_tween.tween_callback(queue_free)
