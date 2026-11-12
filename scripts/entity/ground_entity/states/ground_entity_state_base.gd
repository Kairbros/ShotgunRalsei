class_name GroundEntityStateBase
extends EnemyStateBase

var entity: GroundEntity:
	get():
		return state_machine.controlled_node

func on_physics_process(_delta: float) -> void:
	entity.move_and_slide()
	entity.handle_gravity()
	entity.update_dust()
