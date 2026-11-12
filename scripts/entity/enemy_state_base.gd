class_name EnemyStateBase
extends StateBase

var enemy: Enemy:
	get():
		return state_machine.controlled_node

func is_state_time_over(delta: float) -> bool:
	enemy.state_timer = move_toward(enemy.state_timer, 0.0, delta)
	return enemy.state_timer <= 0.0
