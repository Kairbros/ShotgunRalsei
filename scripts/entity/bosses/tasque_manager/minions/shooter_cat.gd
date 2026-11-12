class_name ShooterCat
extends Minion

class State:
	const EMERGE: StringName = &"Emerge"
	const WIND_UP: StringName = &"WindUp"
	const SHOOT: StringName = &"Shoot"

class Anim:
	const IDLE: StringName = &"idle"
	const WIND_UP: StringName = &"wind_up"
	const ATTACK: StringName = &"attack"

class Sound:
	const MEOW: StringName = &"CatMeow"

@export var spawn_distance: Vector2 = Vector2(110.0, 170.0)
@export var min_target_distance: float = 72.0
@export var emerge_depth: float = 40.0
@export var emerge_duration: float = 0.3
@export var projectile_scene: PackedScene

@onready var muzzle: Marker2D = $Graphics/Muzzle

func spawn(summoner_position: Vector2, new_target: Player, floor_span: Vector2) -> void:
	super(summoner_position, new_target, floor_span)
	var side: float = 1.0 if target.global_position.x >= summoner_position.x else -1.0
	var distance: float = randf_range(spawn_distance.x, spawn_distance.y)
	var spawn_x: float = summoner_position.x + side * distance

	if !is_fair_spot(spawn_x, floor_span):
		spawn_x = summoner_position.x - side * distance

	global_position = Vector2(
		roundf(clampf(spawn_x, floor_span.x, floor_span.y)), summoner_position.y)
	face_target()

func is_fair_spot(spawn_x: float, floor_span: Vector2) -> bool:
	return (spawn_x >= floor_span.x
		and spawn_x <= floor_span.y
		and absf(spawn_x - target.global_position.x) >= min_target_distance)

func fire() -> void:
	var projectile: CatProjectile = projectile_scene.instantiate()
	get_parent().add_child(projectile)
	projectile.launch(muzzle.global_position, target)
	multi_sound_2d.play(Sound.MEOW)
