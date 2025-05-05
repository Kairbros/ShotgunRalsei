extends CharacterBody2D



@export var dañoEnemigo : int = 20
@export var tipoEnemigo: String = "Gato"
@export var empujeEnemigo = Vector2( 300, -300)

var randability :int = 0
# Get the gravity from the project settings to be synced with RigidBody nodes.
var miau = preload("res://Sonidos/Enemigos/TasqueVoiceStages/MiauTasque.wav")
var gravity = 1600
var llendose : bool = false
var catR = preload("res://Sprites/Particulas/CatR.png")
var cat = preload(("res://Sprites/Particulas/Cat.png"))
var proyectil = preload("res://Escenas/Enemigos/Jefes/Tasque/TasqueStages/TasqueCatAtaque.tscn")


func _ready():
	

	if $Textura.flip_h == true:
		$Colision.position.x = 8
		$AreaDamage/Colision.position.x = 8
		$Disparo.position = Vector2(26.333, -21.333)
		$Particula.texture = catR
	if $Textura.flip_h == false:
		$Colision.position.x = -0.6
		$AreaDamage/Colision.position.x = -0.6
		$Disparo.position = Vector2(-16.333, -21.333)
		$Particula.texture = cat
	$AreaDamage/Colision.disabled = true
	
func _physics_process(delta):

	if randability == 1:
	
		StageA(delta)
		if !llendose:
			$Colision.disabled = false
	if randability == 2:
		$Colision.disabled = true
		if !ataco:
			StageB()
	move_and_slide()

var ataco: bool = false

func StageB():
	ataco = true
	z_index = -1
	$Textura.play("Preattack")
	await $Textura.animation_finished

	shoot()
	$Textura.play("Ataque")
	$Sonido.stream = miau
	$Sonido.play()
	await $Textura.animation_finished
	queue_free()


func StageA(delta):
	

	z_index = -1
	if !llendose:
		$Textura.play("quieto")
		velocity.y += gravity*delta
		$Particula.emitting = true
		$AreaDamage/Colision.disabled = false
		
	if llendose:
		$Colision.disabled = true
		$Particula/Luz.enabled = false
		$Luz.enabled = true
		llendose = true
		$Particula.emitting = false
		$AreaDamage/Colision.disabled = true
		velocity.y = 0
		$Textura.play("chao")
		$Luz.energy -= 0.01
		$Textura.modulate.a -= 0.02
		await $Textura.animation_finished
		queue_free()
	

		
		

func _on_area_damage_body_entered(body):
	

	if $Textura.flip_h == true:
		body._golpe(dañoEnemigo, empujeEnemigo, tipoEnemigo)
	else:
		body._golpe(dañoEnemigo, Vector2(-empujeEnemigo.x, empujeEnemigo.y), tipoEnemigo)



	
func shoot():

	var nuevoProyectil = proyectil.instantiate()
	nuevoProyectil.global_position = $Disparo.global_position
	nuevoProyectil.look_at(get_parent().get_node("Jugador").global_position)
	nuevoProyectil.get_node("TasqueAttack/Luz").enabled = true

	get_parent().call_deferred("add_child", nuevoProyectil)


	
