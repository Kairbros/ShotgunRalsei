class_name LevelRegistry

class ScenePath:
	const DEBUG: String = "res://scenes/levels/debug/debug_level_01.tscn"
	const TASQUE_ARENA: String = "res://scenes/levels/tasque_arena/tasque_arena.tscn"
	const NONE: String = ""

class Level:
	var display_name: String
	var scene_path: String
	var icon: Texture2D

	func _init(level_name: String, level_scene_path: String, level_icon: Texture2D) -> void:
		display_name = level_name
		scene_path = level_scene_path
		icon = level_icon

	func is_available() -> bool:
		return !scene_path.is_empty() and ResourceLoader.exists(scene_path)

class Icon:
	const DEBUG: Texture2D = preload("res://assets/sprites/menus/level_select/level_debug.png")
	const TASQUE: Texture2D = preload("res://assets/sprites/menus/level_select/level_tasque.png")
	const SANS: Texture2D = preload("res://assets/sprites/menus/level_select/level_sans.png")

static func get_levels() -> Array[Level]:
	return [
		Level.new("Prueba", ScenePath.DEBUG, Icon.DEBUG),
		Level.new("Tasque Manager", ScenePath.TASQUE_ARENA, Icon.TASQUE),
		Level.new("Sans", ScenePath.NONE, Icon.SANS),
	]

static func is_level(scene_path: String) -> bool:
	return !scene_path.is_empty() and get_levels().any(
		func(level: Level) -> bool: return level.scene_path == scene_path)
