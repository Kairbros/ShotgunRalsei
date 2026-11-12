extends TasqueStateBase

var timeline: Tween = null

func start() -> void:
	timeline = boss.create_tween()
	timeline.tween_interval(boss.blackout_duration)
	timeline.tween_callback(boss.multi_sound_2d.play.bind(TasqueManager.Voice.LAUGH))
	timeline.tween_interval(boss.laugh_duration)
	timeline.tween_callback(boss.reveal)
	timeline.tween_interval(boss.reveal_duration)
	timeline.tween_callback(state_machine.change_state.bind(TasqueManager.State.ATTACK))

func exit() -> void:
	timeline.kill()
