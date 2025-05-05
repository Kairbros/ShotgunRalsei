extends CharacterBody2D

@onready var enemyCat = preload("res://Escenas/Enemigos/Jefes/Tasque/TasqueStages/TasqueCat.tscn")
@onready var alert = preload("res://Escenas/Miscelaneos/Ambiente/alertaLuz.tscn")
@onready var enemyCarDog = preload("res://Escenas/Enemigos/Terrestres/AnnoyingDog.tscn")
@onready var risa = preload("res://Sonidos/Enemigos/TasqueLaugh.wav")
@onready var click = preload("res://Sonidos/Ambientacion/ClickSound.wav")
@onready var A = preload("res://Sonidos/Enemigos/TasqueVoiceStages/TasqueA.wav")
@onready var B = preload("res://Sonidos/Enemigos/TasqueVoiceStages/TasqueB.wav")
@onready var C = preload("res://Sonidos/Enemigos/TasqueVoiceStages/TasqueC.wav")
@onready var D = preload("res://Sonidos/Enemigos/TasqueVoiceStages/TasqueD.wav")
@onready var defeat = preload("res://Sonidos/Enemigos/TasqueVoiceStages/TasqueSpare.wav")
@onready var tasqueR  = preload("res://Sprites/Particulas/tasqueP.png")
@onready var tasqueL  = preload("res://Sprites/Particulas/tasqueL.png")
@export var tipoEnemigo: String = "tasqueManager"


var jugadorDistanciaA
var jugador

var estaGirado : bool
var muriendo : bool = false

var dañoJugadorA : int = 0
@export var vida: int = 60
var gravedad : int 
var randability : int = 0
var randCat : int = 0

var segundosMovimiento : float = 0
var gatoTiempo : float =  1.5
var vidaTotal : float

var stageOneCatList: Array
var stageOnelightList : Array
var stageTwoCatList : Array
var stageTwolightList : Array
var stageThreeCatList : Array
var stageThreelightList : Array



func _ready():
	gravedad = get_parent().gravedad
	$Luz.visible = false
	$AnimNode.visible  = false
	
func _physics_process(delta):
	if is_on_wall():
		segundosMovimiento = 0.9
		velocity.x = 0

	if !is_on_floor() and !muriendo:
		velocity.y += gravedad*delta
		velocity.x = 0

	if jugador != null:
		$Rayo.target_position = to_local(jugador.position)
	if jugadorDistanciaA:
		if !$Rayo.is_colliding():
			if self.position < jugadorDistanciaA.position and velocity.x == 0:
				$Colision.position.x = -21
				$AnimNode/Cabeza.flip_h = false
				$AnimNode/Cola.flip_h = false
				$AnimNode/ManoSin.flip_h = false
				$AnimNode/Piernas.flip_h = false
				$AnimNode/Torso.flip_h = false
				estaGirado = true
			elif self.position > jugadorDistanciaA.position and velocity.x == 0:
				$Colision.position.x = 0
				$AnimNode/Cabeza.flip_h = true
				$AnimNode/Cola.flip_h = true
				$AnimNode/ManoSin.flip_h = true
				$AnimNode/Piernas.flip_h = true
				$AnimNode/Torso.flip_h = true
				estaGirado = false
			
	
			if randability == 1:
		
				moveSetOne(delta)
				
			if randability == 2:
		
				moveSetTwo(delta)
				
			if randability == 3:
		
				moveSetThree(delta)
				

	StageChange(delta)
	shaderController()
	move_and_slide()


func moveSetThree(delta):

	for i in range(stageThreeCatList.size()):
		if dañoJugadorA >= 5 and stageThreeCatList[i] != null:
			stageThreeCatList[i].queue_free()
			stageThreelightList[i].queue_free()
			stageThreeCatList.remove_at(i) #Use listas para verificar si hay un gato e irlos eliminando, si el gato en la posicion 0 esta en Y > Y objetivo, se elimina la luz y se remeuve de la lista
			stageThreelightList.remove_at(i)
			break
			
		if stageThreeCatList[0] == null :

			stageThreelightList[0].queue_free()
			stageThreeCatList.remove_at(0)
			stageThreelightList.remove_at(0)
			break

		if stageThreeCatList[0].position.y >= $MarcadorPiso.global_position.y - 10 and stageThreeCatList[0].randability == 1:
			stageThreeCatList[0].position.y = position.y - 20
			stageThreeCatList[0].llendose = true
			stageThreelightList[0].queue_free()
			stageThreeCatList.remove_at(0) #Use listas para verificar si hay un gato e irlos eliminando, si el gato en la posicion 0 esta en Y > Y objetivo, se elimina la luz y se remeuve de la lista
			stageThreelightList.remove_at(0)
			break
	
		

	if gatoTiempo > 0:
		gatoTiempo -= delta

	if gatoTiempo <= 0:

		if  vida <= vidaTotal * 35 / 100:

			gatoTiempo = 0.9
		else:
			gatoTiempo = 1.2
		randCat = randi_range(1,2)
		HabilidadThree()

func moveSetTwo(delta):


	for i in range(stageTwoCatList.size()):
		if dañoJugadorA >= 5:
			stageTwoCatList[i].queue_free()
			stageTwolightList[i].queue_free()
			stageTwoCatList.remove_at(i) #Use listas para verificar si hay un gato e irlos eliminando, si el gato en la posicion 0 esta en Y > Y objetivo, se elimina la luz y se remeuve de la lista
			stageTwolightList.remove_at(i)
			break
		if stageTwoCatList[0] == null :
			stageTwolightList[0].queue_free()
			stageTwoCatList.remove_at(0)
			stageTwolightList.remove_at(0)
			break
	
	
		
	if gatoTiempo > 0:
		gatoTiempo -= delta
		
	if gatoTiempo <= 0:

		if  vida <= vidaTotal * 55 / 100:

			gatoTiempo = 1
		else:
			gatoTiempo = 1.3
		randCat = randi_range(1,2)
		HabilidadTwo()

func moveSetOne(delta):

	for i in range(stageOneCatList.size()):
		if dañoJugadorA >= 5:
			stageOneCatList[i].queue_free()
			stageOnelightList[i].queue_free()
			stageOneCatList.remove_at(i) #Use listas para verificar si hay un gato e irlos eliminando, si el gato en la posicion 0 esta en Y > Y objetivo, se elimina la luz y se remeuve de la lista
			stageOnelightList.remove_at(i)
			break
		if stageOneCatList[0].position.y >= $MarcadorPiso.global_position.y -10 :
			stageOneCatList[0].position.y = position.y - 20
			stageOneCatList[0].llendose = true
			stageOnelightList[0].queue_free()
			stageOneCatList.remove_at(0) #Use listas para verificar si hay un gato e irlos eliminando, si el gato en la posicion 0 esta en Y > Y objetivo, se elimina la luz y se remeuve de la lista
			stageOnelightList.remove_at(0)
			break
	
	
	
	if gatoTiempo > 0:
		gatoTiempo -= delta
		
	if gatoTiempo <= 0:
		
		if vida <= vidaTotal * 75 / 100:
			
			gatoTiempo = 0.5
		else:
			gatoTiempo = 0.8
		Habilidad()

func StageChange(delta):

	var randvel = randi_range(800, 900)
	if velocity.x != 0 and !muriendo:
		$Luz.enabled = false
		$Particula/Luz.enabled = true
		gatoTiempo = 1
		segundosMovimiento += delta
		if segundosMovimiento >= 0.8:
			segundosMovimiento = 0.0
			velocity.x = 0
			$Particula.emitting = false
			aparacerAnnoyingDog()
			$Sonido.stream = click
			$Sonido.play()
			await $Sonido.finished
			if vida >= vidaTotal * 66 / 100:
				randability = 1
			if vida <= vidaTotal * 65 / 100 and vida >= vidaTotal * 35/100:
				randability = 2
			if vida <= vidaTotal * 34 / 100:
				randability = 3
			sonidoStage()
	
	else: 
		$Luz.enabled = true
		$Particula/Luz.enabled = false

	if  dañoJugadorA >= 5 and vida != 0  and !muriendo : 
		dañoJugadorA = 0
		$Particula.emitting = true
		var random: int = randi_range(1,2)
		if random == 1:	
			if $Left.is_colliding():
				velocity.x = randvel
			else:
				velocity.x = -randvel
		else:
			if $Right.is_colliding():
				velocity.x = -randvel
			else:
				velocity.x = randvel

func _hit(dañoJugador):
	
	dañoJugadorA += dañoJugador
	
	jugador.get_node("HUD/Canvas/ControlJefe/BossBar").value -= dañoJugador
	vida -= dañoJugador

	if  vida <= 0:
		if randability == 1:
			for i in range(stageOnelightList.size()):
				stageOneCatList[i].queue_free()
				stageOnelightList[i].queue_free()
				break
		if randability == 2:
			for i in range(stageTwolightList.size()):
				stageTwoCatList[i].queue_free()
				stageTwolightList[i].queue_free()
				break
		if randability == 3:
			for i in range(stageThreelightList.size()):
				stageThreeCatList[i].queue_free()
				stageThreelightList[i].queue_free()
				break
		muriendo = true
		$Colision.queue_free() 
		$CatDetector/Colision.queue_free()
		$Sonido.stream = defeat
		$Sonido.play()
		await $Sonido.finished
		get_parent().bossfightend()
		$AnimNode/Cabeza.play("default")
		await  $AnimNode/Cabeza.animation_finished
		queue_free() #elimina el objeto

	
func shaderController():
	

	if velocity.x < 0:
		$Particula/Luz.position = $AnimNode.position
	else:
		$Particula/Luz.position = $AnimNode.position
		
	if estaGirado:
#		$Particula.process_material.direction.x = -1
		$Particula.position.x = -10
		$Particula.texture = tasqueR
	else:
#		$Particula.process_material.direction.x = 1
		$Particula.position.x = 6.8
		$Particula.texture = tasqueL
		
	
		
	if muriendo:

		velocity.x = -3000
		$Luz.enabled = false

func _detectoEnemigo(body):
	
	if !$Rayo.is_colliding():
		$Rayo.enabled = false 
		vidaTotal = vida
		randability = 1
		$CatDetector/Colision.scale = Vector2(2,2)
		get_parent().get_node("Iluminacion").energy = 0.0
		get_parent().apagar()
		await get_parent().get_node("Backgroundmusic").finished
		$Sonido.volume_db = -1
		$Sonido.stream = risa
		$Sonido.play()
		await $Sonido.finished
		$Sonido.stream = click
		body.get_node("HUD").bossBar(tipoEnemigo, vida, vidaTotal)
		$Sonido.play()
		$Luz.enabled = true
		$Luz.visible = true
		get_parent().get_node("Iluminacion").energy = 0.35
		$Colision.disabled = false
		$AnimNode.visible  = true
		get_parent().bossfight(tipoEnemigo)
		position.x = get_parent().get_node("Jugador").position.x
		jugadorDistanciaA = body
		await $Sonido.finished
		$Sonido.volume_db = 5
		sonidoStage()


func sonidoStage():
	
	
	if randability == 1:
		$Sonido.stream = A
		$Sonido.play()
	if randability == 2:
		$Sonido.stream = B
		$Sonido.play()
	if randability == 3:
		$Sonido.stream = C
		$Sonido.play()
	if randability == 4:
		$Sonido.stream = D
		$Sonido.play()

func _enemigoSalio(_body):
	jugadorDistanciaA = null

func Habilidad():
	

	var newalert = alert.instantiate()
	var nuevoTasque = enemyCat.instantiate()
	

	nuevoTasque.randability = 1

			
	$AparecerCat.position = to_local(Vector2(jugadorDistanciaA.position.x , self.position.y - 750))
	$Indicador.position = $AparecerCat.position
	
	newalert.global_position = Vector2($Indicador.global_position.x, $Luz.global_position.y)
	nuevoTasque.global_position = $AparecerCat.global_position
	
	if estaGirado:
		nuevoTasque.get_node("Textura").flip_h = true
	else: 
		nuevoTasque.get_node("Textura").flip_h = false

	
	get_parent().add_child(newalert)
	get_parent().add_child(nuevoTasque)
	
	stageOneCatList.append(nuevoTasque)
	stageOnelightList.append(newalert)

func HabilidadTwo():
	var newalert = alert.instantiate()
	var nuevoTasque = enemyCat.instantiate()
	
	nuevoTasque.randability = 2
	

	if estaGirado:
		nuevoTasque.get_node("Textura").flip_h = true
	else: 
		nuevoTasque.get_node("Textura").flip_h = false
	get_parent().add_child(newalert)
	get_parent().add_child(nuevoTasque)
	
	if randCat == 1:
		$AparecerCat.position = to_local(Vector2(self.position.x + randi_range(-500, -400), $MarcadorPiso.global_position.y ))
		$Indicador.position = $AparecerCat.position
	else:
		$AparecerCat.position = to_local(Vector2(self.position.x + randi_range(500, 400), $MarcadorPiso.global_position.y ))
		$Indicador.position = $AparecerCat.position
		
	newalert.global_position = Vector2($Indicador.global_position.x, $Luz.global_position.y)
	nuevoTasque.global_position = $AparecerCat.global_position
	
	stageTwoCatList.append(nuevoTasque)
	stageTwolightList.append(newalert)

func HabilidadThree():
	
	var newalert = alert.instantiate()
	var nuevoTasque = enemyCat.instantiate()
	
	nuevoTasque.randability = randi_range(1,2)

	if nuevoTasque.randability == 1:
		$AparecerCat.position = to_local(Vector2(jugadorDistanciaA.position.x , self.position.y -750))
		$Indicador.position = $AparecerCat.position
	
		newalert.global_position = Vector2($Indicador.global_position.x, $Luz.global_position.y)
		nuevoTasque.global_position = $AparecerCat.global_position
		
	if nuevoTasque.randability == 2:
	
		if randCat == 1:
			$AparecerCat.position = to_local(Vector2(self.position.x + randi_range(-500, -400), $MarcadorPiso.global_position.y ))
			$Indicador.position = $AparecerCat.position
		else:
			$AparecerCat.position = to_local(Vector2(self.position.x + randi_range(500, 400), $MarcadorPiso.global_position.y ))
			$Indicador.position = $AparecerCat.position
			
		newalert.global_position = Vector2($Indicador.global_position.x, $Luz.global_position.y)
		nuevoTasque.global_position = $AparecerCat.global_position
		
	if estaGirado:
		nuevoTasque.get_node("Textura").flip_h = true
	else: 
		nuevoTasque.get_node("Textura").flip_h = false
		
	get_parent().add_child(newalert)
	get_parent().add_child(nuevoTasque)
	stageThreeCatList.append(nuevoTasque)
	stageThreelightList.append(newalert)

func aparacerAnnoyingDog():
		
	var nuevoAnnoyingDog = enemyCarDog.instantiate()
	nuevoAnnoyingDog.global_position = $CarAparecer.global_position
	nuevoAnnoyingDog.scale = Vector2(0.9, 0.9)
	nuevoAnnoyingDog.vida = 3
	nuevoAnnoyingDog.get_node("Textura").self_modulate = Color(0,150,1200) 
	nuevoAnnoyingDog.dañoEnemigo = 15
	nuevoAnnoyingDog.get_node("Luz").enabled = true

	get_parent().add_child(nuevoAnnoyingDog)

func _detectoParedEntrada(body):
	jugador = body


func _detectorParedSalida(_body):
	jugador = null
