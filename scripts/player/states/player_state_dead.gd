extends PlayerStateBase

const LAUNCH_FORCE: float = -540.0
const HIT_STOP_DURATION: float = 0.2
const GAME_OVER_DELAY: float = 0.8

var death_announced: bool = false

func start() -> void:
	death_announced = false
	player.velocity = Vector2(0.0, LAUNCH_FORCE)
	player.collider.set_disabled.call_deferred(true)
	player.animated_sprite.play(Player.Anim.DEAD)
	VFX.stop_blink(player.animated_sprite)
	VFX.flash(player.animated_sprite)
	player.play_feedback(
		Player.Sound.HURT, Player.Particle.HIT, player.global_position + Player.BODY_CENTER)
	player.shake_camera(Player.ShakeMagnitude.DEAD)
	GameFeeling.hit_stop(player.get_tree(), HIT_STOP_DURATION)
	player.camera_player.set_physics_process(false)

func on_physics_process(delta: float) -> void:
	super(delta)

	if death_announced or player.animated_sprite.is_playing():
		return

	death_announced = true
	player.died.emit()
	open_game_over_later()

func open_game_over_later() -> void:
	var game_over_tween: Tween = player.create_tween()
	game_over_tween.tween_interval(GAME_OVER_DELAY)
	game_over_tween.tween_callback(GameManager.open_game_over.bind(player))
