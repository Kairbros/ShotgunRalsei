extends Node

const TRANSITION_SCENE: PackedScene = preload("res://scenes/menus/transition.tscn")
const PAUSE_MENU_SCENE: PackedScene = preload("res://scenes/menus/pause_menu.tscn")
const SCENE_NOT_FOUND_ERROR: String = "Scene not found: "

class ScenePath:
	const MAIN_MENU: String = "res://scenes/menus/main_menu.tscn"
	const LEVEL_SELECT: String = "res://scenes/menus/level_select.tscn"
	const GAME_OVER: String = "res://scenes/menus/game_over.tscn"

var current_level_path: String = ""
var transition: Transition = null
var pause_menu: PauseMenu = null

func _ready() -> void:
	pause_menu = PAUSE_MENU_SCENE.instantiate()
	add_child(pause_menu)
	get_tree().scene_changed.connect(on_scene_changed)
	on_scene_changed.call_deferred()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(InputNames.Menu.PAUSE) and can_pause():
		get_viewport().set_input_as_handled()
		pause()

func change_scene(scene_path: String) -> void:
	if is_changing():
		return

	if !ResourceLoader.exists(scene_path):
		push_error(SCENE_NOT_FOUND_ERROR + scene_path)
		return

	start_transition().cover_to(scene_path)

func open_main_menu() -> void:
	change_scene(ScenePath.MAIN_MENU)

func open_level_select() -> void:
	change_scene(ScenePath.LEVEL_SELECT)

func open_level(level: LevelRegistry.Level) -> void:
	change_scene(level.scene_path)

func retry_level() -> void:
	change_scene(current_level_path)

func open_game_over(fallen_node: Node) -> void:
	if !is_in_level():
		var level: Node = fallen_node.owner if fallen_node.owner else fallen_node
		current_level_path = level.scene_file_path

	change_scene(ScenePath.GAME_OVER)

func quit_game() -> void:
	if !is_changing():
		start_transition().cover_then(get_tree().quit)

func start_transition() -> Transition:
	transition = TRANSITION_SCENE.instantiate()
	add_child(transition)
	return transition

func is_changing() -> bool:
	return is_instance_valid(transition)

func is_in_level() -> bool:
	var scene: Node = get_tree().current_scene
	return scene != null and LevelRegistry.is_level(scene.scene_file_path)

func can_pause() -> bool:
	return is_in_level() and !is_changing() and !get_tree().paused

func pause() -> void:
	get_tree().paused = true
	pause_menu.open()
	update_mouse_mode()

func resume() -> void:
	pause_menu.close()
	get_tree().paused = false
	update_mouse_mode()

func on_scene_changed() -> void:
	get_tree().paused = false
	pause_menu.close()

	if is_in_level():
		current_level_path = get_tree().current_scene.scene_file_path

	update_mouse_mode()

func update_mouse_mode() -> void:
	Input.mouse_mode = get_wanted_mouse_mode()

func get_wanted_mouse_mode() -> Input.MouseMode:
	return (
		Input.MOUSE_MODE_CONFINED_HIDDEN if is_in_level() and !get_tree().paused
		else Input.MOUSE_MODE_VISIBLE)
