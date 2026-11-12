class_name TasqueStateBase
extends EnemyStateBase

var boss: TasqueManager:
	get():
		return state_machine.controlled_node

func on_physics_process(_delta: float) -> void:
	boss.move_and_slide()
	boss.handle_gravity()
