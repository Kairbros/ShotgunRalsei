class_name GroundEntity
extends Entity

const DUST_MIN_SPEED: float = 40.0

@onready var edge_detector: RayCast2D = $Graphics/EdgeDetector
@onready var dust: CPUParticles2D = $Graphics/Particles/Dust

func drive(direction: float) -> void:
	handle_movement(speed_force * Acceleration.HIGH, direction)
	animated_sprite.play(Anim.WALK)

func halt() -> void:
	velocity.x = 0.0
	animated_sprite.play(Anim.IDLE)

func is_at_ledge() -> bool:
	edge_detector.force_raycast_update()
	return !edge_detector.is_colliding()

func update_dust() -> void:
	dust.emitting = is_on_floor() and absf(velocity.x) > DUST_MIN_SPEED
