extends PlayerStateAction

const RECOIL_FORCE: float = 90.0
const SHOTGUN_BLAST_SCENE: PackedScene = preload("res://scenes/player/shotgun_blast.tscn")

func start() -> void:
	player.input_buffer.end()
	player.handle_rotation()
	player.velocity.x = -player.get_facing() * RECOIL_FORCE
	player.animated_sprite.play(Player.Anim.SHOOT)
	VFX.squash(player.animated_sprite)
	fire_shotgun()

func on_action_process(delta: float) -> void:
	super(delta)
	player.input_buffer.update(delta)

func on_unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(InputNames.Fight.ATTACK):
		player.input_buffer.start(InputNames.Fight.ATTACK)

	super(event)

func get_requested_state(event: InputEvent) -> StringName:
	return get_mobility_request(event)

func finish() -> void:
	if player.input_buffer.is_active(InputNames.Fight.ATTACK) and player.is_on_floor():
		state_machine.change_state(Player.State.SHOOT)
		return

	super()

func exit() -> void:
	player.input_buffer.end()

func fire_shotgun() -> void:
	var shotgun_blast: ShotgunBlast = SHOTGUN_BLAST_SCENE.instantiate()
	player.muzzle.add_child(shotgun_blast)
	shotgun_blast.hitbox.setup_hitbox(
		player.damage_amount * player.parry_buff.get_damage_multiplier(), player.knockback_potency)
	shotgun_blast.hitbox.hit_landed.connect(on_shot_landed)

	player.play_feedback(Player.Sound.SHOTGUN, Player.Particle.MUZZLE, player.muzzle.global_position)
	player.multi_particle_2d.emit(
		Player.Particle.SHELL, player.shell_ejector.global_position, player.get_facing())
	player.shake_camera(Player.ShakeMagnitude.SHOOT)

func on_shot_landed(target_hurtbox: Hurtbox) -> void:
	player.power_meter.charge()
	player.multi_particle_2d.emit(
		Player.Particle.HIT, target_hurtbox.global_position, player.get_facing())
	player.shake_camera(Player.ShakeMagnitude.HIT_TARGET)
