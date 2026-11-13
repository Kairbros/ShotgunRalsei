extends TasqueStateBase

var timeline: Tween = null

func start() -> void:
	boss.velocity = Vector2.ZERO
	boss.set_vulnerable(false)
	boss.set_contact_damage(false)
	boss.set_dash_pose(false)
	boss.animated_sprite.position = Vector2.ZERO
	boss.clear_minions()
	boss.multi_sound_2d.play(TasqueManager.Voice.SPARE)
	VFX.blink(boss.animated_sprite, boss.spare_duration)
	timeline = boss.create_tween()
	timeline.tween_interval(boss.spare_duration)
	timeline.tween_callback(boss.burst)

func on_physics_process(delta: float) -> void:
	super(delta)
	boss.handle_friction(Enemy.Acceleration.HIGH)

func exit() -> void:
	timeline.kill()
