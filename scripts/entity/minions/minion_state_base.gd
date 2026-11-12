class_name MinionStateBase
extends EnemyStateBase

var minion: Minion:
	get():
		return state_machine.controlled_node

func on_physics_process(delta: float) -> void:
	minion.move(delta)
