extends TasqueStateBase

func start() -> void:
	boss.graphics.hide()
	boss.set_vulnerable(false)
	boss.set_contact_damage(false)
	boss.player_detector.body_entered.connect(on_player_detector_body_entered)

func exit() -> void:
	boss.player_detector.body_entered.disconnect(on_player_detector_body_entered)

func on_player_detector_body_entered(body: Node2D) -> void:
	if body is Player:
		boss.awaken(body as Player)
		state_machine.change_state(TasqueManager.State.INTRO)
