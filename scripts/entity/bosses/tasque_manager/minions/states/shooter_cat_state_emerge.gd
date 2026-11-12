extends MinionStateBase

var emerge_tween: Tween = null

func start() -> void:
	var cat: ShooterCat = minion as ShooterCat
	cat.set_vulnerable(false)
	cat.set_contact_damage(false)
	cat.animated_sprite.play(ShooterCat.Anim.IDLE)
	emerge_tween = cat.create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	emerge_tween.tween_method(
		set_rise, Vector2.DOWN * cat.emerge_depth, Vector2.ZERO, cat.emerge_duration)
	emerge_tween.tween_callback(state_machine.change_state.bind(ShooterCat.State.WIND_UP))

func exit() -> void:
	emerge_tween.kill()
	minion.animated_sprite.position = Vector2.ZERO

func set_rise(offset: Vector2) -> void:
	minion.animated_sprite.position = offset.round()
