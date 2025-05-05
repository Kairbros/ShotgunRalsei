extends CharacterBody2D


@export var cat :PackedScene 
@export var alert :PackedScene 
@export var car :PackedScene 
@export var vida: int = 60
@export var tipoEnemigo: String = "tasqueManager"

var risa = load("res://Sonidos/Enemigos/TasqueLaugh.wav")
var click = load("res://Sonidos/Ambientacion/ClickSound.wav")
var A = load("res://Sonidos/Enemigos/TasqueVoiceStages/TasqueA.wav")
var B = load("res://Sonidos/Enemigos/TasqueVoiceStages/TasqueB.wav")
var C = load("res://Sonidos/Enemigos/TasqueVoiceStages/TasqueC.wav")
var D = load("res://Sonidos/Enemigos/TasqueVoiceStages/TasqueD.wav")
var defeat = load("res://Sonidos/Enemigos/TasqueVoiceStages/TasqueSpare.wav")

var gatoN : float =  1.5
var gravedad =5000
var jugadorDistancia
var jugadorDistanciaA

var estagirado : bool
var jugador

var ataque: bool = false


var numeroimpB : int = 0

var muriendo : bool = false
var segundosmove : float = 0

var StageOneCatList: Array
var StageOnelightList : Array

var StageTwoCatList : Array
var StageTwolightList : Array

var StageThreeCatList : Array
var StageThreelightList : Array

var vidaTotal : int
var randability : int = 0

func _ready():

	$Luz.visible = false
	$AnimNode.visible  = false
	$Colision.disabled = true
	$AnimNode.material.set("shader_parameter/fade" , 1)
	jugador = get_parent().find_child("Player")
	
func _physics_process(delta):
	
	if is_on_wall():
		segundosmove = 0.9
		velocity.x = 0
		
	if !is_on_floor() and !muriendo and $AnimNode.visible  == true:
		velocity.y += gravedad*delta
		velocity.x = 0

	if jugadorDistanciaA:

		$Rayo.target_position = to_local(jugador.position)
		
		if !$Rayo.is_colliding():
			
			if self.position < jugadorDistanciaA.position and velocity.x == 0:
				$AnimNode/Cabeza.flip_h = false
				$AnimNode/Cola.flip_h = false
				$AnimNode/ManoCon.flip_h = false
				$AnimNode/ManoSin.flip_h = false
				$AnimNode/Piernas.flip_h = false
				$AnimNode/Torso.flip_h = false
				estagirado = true
			elif self.position > jugadorDistanciaA.position and velocity.x == 0:
				$AnimNode/Cabeza.flip_h = true
				$AnimNode/Cola.flip_h = true
				$AnimNode/ManoCon.flip_h = true
				$AnimNode/ManoSin.flip_h = true
				$AnimNode/Piernas.flip_h = true
				$AnimNode/Torso.flip_h = true
				estagirado = false
			
	
			if randability == 1:
		
				moveSetOne(delta)
				
			if randability == 2:
		
				moveSetTwo(delta)
				
			if randability == 3:
		
				moveSetThree(delta)
				

	StageChange(delta)
	shaderController()
	move_and_slide()

var randCat : int = 0

func moveSetThree(delta):


	if !muriendo:
		for i in range(StageThreeCatList.size()):
			if numeroimpB >= 5:
				StageThreeCatList[i].queue_free()
				StageThreelightList[i].queue_free()
				StageThreeCatList.remove_at(i) #Use listas para verificar si hay un gato e irlos eliminando, si el gato en la posicion 0 esta en Y > Y objetivo, se elimina la luz y se remeuve de la lista
				StageThreelightList.remove_at(i)
				break
				
			if StageThreeCatList[0] == null and numeroimpB !=5 :

				StageThreelightList[0].queue_free()
				StageThreeCatList.remove_at(0)
				StageThreelightList.remove_at(0)
				break

			if StageThreeCatList[0].position.y >= self.position.y -10 and numeroimpB !=5 and  StageThreeCatList[0].randability == 1:
				
				StageThreeCatList[0].position.y = position.y -10
				StageThreeCatList[0].llendose = true
				StageThreelightList[0].queue_free()
				StageThreeCatList.remove_at(0) #Use listas para verificar si hay un gato e irlos eliminando, si el gato en la posicion 0 esta en Y > Y objetivo, se elimina la luz y se remeuve de la lista
				StageThreelightList.remove_at(0)
				break
			
		

	if gatoN > 0:
		gatoN -= delta

	if gatoN <= 0:

		if  vida <= vidaTotal / 2.0:

			gatoN = 0.9
		else:
			gatoN = 1.2
		randCat = randi_range(1,2)
		HabilidadThree()

func moveSetTwo(delta):

	if !muriendo:
		for i in range(StageTwoCatList.size()):
			if numeroimpB >= 5:
				StageTwoCatList[i].queue_free()
				StageTwolightList[i].queue_free()
				StageTwoCatList.remove_at(i) #Use listas para verificar si hay un gato e irlos eliminando, si el gato en la posicion 0 esta en Y > Y objetivo, se elimina la luz y se remeuve de la lista
				StageTwolightList.remove_at(i)
				break
			if StageTwoCatList[0] == null and numeroimpB !=5 :
				StageTwolightList[0].queue_free()
				StageTwoCatList.remove_at(0)
				StageTwolightList.remove_at(0)
				break
	
	
		
	if gatoN > 0:
		gatoN -= delta
		
	if gatoN <= 0:

		if  vida <= vidaTotal / 2.0:

			gatoN = 1
		else:
			gatoN = 1.3
		randCat = randi_range(1,2)
		HabilidadTwo()

func moveSetOne(delta):
	

	if !muriendo:
		for i in range(StageOneCatList.size()):
			if numeroimpB >= 5:
				StageOneCatList[i].queue_free()
				StageOnelightList[i].queue_free()
				StageOneCatList.remove_at(i) #Use listas para verificar si hay un gato e irlos eliminando, si el gato en la posicion 0 esta en Y > Y objetivo, se elimina la luz y se remeuve de la lista
				StageOnelightList.remove_at(i)
				break
			if StageOneCatList[0].position.y >= self.position.y -10 and numeroimpB !=5 :
				StageOneCatList[0].position.y = position.y -10
				StageOneCatList[0].llendose = true
				StageOnelightList[0].queue_free()
				StageOneCatList.remove_at(0) #Use listas para verificar si hay un gato e irlos eliminando, si el gato en la posicion 0 esta en Y > Y objetivo, se elimina la luz y se remeuve de la lista
				StageOnelightList.remove_at(0)
				break
		

	
	if gatoN > 0:
		gatoN -= delta
		
	if gatoN <= 0:
		
		if vida <= vidaTotal / 2.0:
			
			gatoN = 0.5
		else:
			gatoN = 0.8
		Habilidad()

func StageChange(delta):
	var randvel = randi_range(800, 900)

	if velocity.x != 0 and !muriendo:
		$Luz.enabled = false
		$Particula/Luz.visible = true
		
		gatoN = 1
			
		segundosmove += delta
		
		if segundosmove >= 0.8:
			segundosmove = 0.0
			velocity.x = 0
			$Particula.emitting = false
			aparcercarro()
			$Sonido.stream = click
			$Sonido.play()
			await $Sonido.finished
			randability = randi_range(1,3)
			sonidoStage()
	
	else: 
		$Luz.enabled = true
		$Particula/Luz.visible = false

	if  numeroimpB >= 5 and vida != 0  and !muriendo : 
		numeroimpB = 0
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

func dead(numeroimp):
	
	numeroimpB += numeroimp
	
	jugador.get_node("HUD/CanvasLayer/BossBar").value -= numeroimp
	vida -= numeroimp

	if  vida <= 0:
		if randability == 1:
			for i in range(StageOneCatList.size()):
				print(StageOneCatList)
				StageOneCatList[i].queue_free()
				StageOnelightList[i].queue_free()
				StageOneCatList.clear()
				StageOnelightList.clear()
				print(StageOneCatList)
				print("entro 1")
				break
		if randability == 2:
			for i in range(StageTwoCatList.size()):
				print(StageTwoCatList)
				StageTwoCatList[i].queue_free()
				StageTwolightList[i].queue_free()
				StageTwoCatList.clear()
				StageTwolightList.clear()
				print(StageTwoCatList)
				print("entro 2")
				break
		if randability == 3:
			for i in range(StageThreeCatList.size()):
				print(StageThreeCatList)
				StageThreeCatList[i].queue_free()
				StageThreeCatList[i].queue_free()
				StageThreeCatList.clear()
				StageThreelightList.clear()
				print(StageThreeCatList)
				print("entro 3")
				break
		muriendo = true
		$Colision.queue_free() 
		$CatDetector/CollisionShape2D.queue_free()
		$Sonido.stream = defeat
		$Sonido.play()
		await $Sonido.finished
		get_parent().bossfightend()
		$AnimNode/Cabeza.play("default")
		await  $AnimNode/Cabeza.animation_finished
		
		queue_free() #elimina el objeto

@onready var desaparecer  = preload("res://Shader/Disolver.tres")
@onready var blink  = preload("res://Shader/Blink.tres")
@onready var tasqueR  = preload("res://Sprites/Particulas/tasqueP.png")
@onready var tasqueL  = preload("res://Sprites/Particulas/tasqueL.png")

func shaderController():
	

	if velocity.x < 0:
		$Particula/Luz.position = Vector2(56, -1)
	else:
		$Particula/Luz.position = Vector2(-56, -1)
		
	if estagirado:
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
		var fade = $AnimNode.material.get("shader_parameter/fade")
		$AnimNode.material.set("shader_parameter/fade" , fade - 0.016)
	else:
		$AnimNode.material.shader = desaparecer

func _on_cat_detector_body_entered(body):
	vidaTotal = vida
	randability = randi_range(1,3)
	$CatDetector/CollisionShape2D.scale = Vector2(2,2)
	get_parent().get_node("Iluminacion").color = "090909"
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
	get_parent().get_node("Iluminacion").color = "868686"
	$Colision.disabled = false
	$AnimNode.visible  = true
	get_parent().bossfight(tipoEnemigo)
	position.x = get_parent().get_node("Player").position.x
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

func _on_cat_detector_body_exited(_body):
	
	jugadorDistanciaA = null

func Habilidad():
	

	var newalert = alert.instantiate()
	var newcat = cat.instantiate()
	

	newcat.randability = 1

			
	$AparecerCat.position = to_local(Vector2(jugadorDistanciaA.position.x , -100))
	$Indicador.position = $AparecerCat.position
	
	
	newalert.global_position = $Indicador.global_position
	
	newcat.global_position = $AparecerCat.global_position
	
	if estagirado:
		newcat.get_node("Textura").flip_h = true
	else: 
		newcat.get_node("Textura").flip_h = false

	
	get_parent().add_child(newalert)
	get_parent().add_child(newcat)
	
	StageOneCatList.append(newcat)
	StageOnelightList.append(newalert)

func HabilidadTwo():
	var newalert = alert.instantiate()
	var newcat = cat.instantiate()
	
	newcat.randability = 2
	

	if estagirado:
		newcat.get_node("Textura").flip_h = true
	else: 
		newcat.get_node("Textura").flip_h = false
	get_parent().add_child(newalert)
	get_parent().add_child(newcat)
	
	if randCat == 1:
		$AparecerCat.position = to_local(Vector2(self.position.x + randi_range(-500, -400), self.position.y ))
		$Indicador.position = $AparecerCat.position
	else:
		$AparecerCat.position = to_local(Vector2(self.position.x + randi_range(500, 400), self.position.y ))
		$Indicador.position = $AparecerCat.position
		
	newalert.global_position = Vector2($Indicador.global_position.x, -100)
	newcat.global_position = $AparecerCat.global_position
	
	StageTwoCatList.append(newcat)
	StageTwolightList.append(newalert)

func HabilidadThree():
	
	var newalert = alert.instantiate()
	var newcat = cat.instantiate()
	
	newcat.randability = randi_range(1,2)

	if newcat.randability == 1:
		$AparecerCat.position = to_local(Vector2(jugadorDistanciaA.position.x , -100))
		$Indicador.position = $AparecerCat.position
	
		newalert.global_position = Vector2($Indicador.global_position.x, -100)
		newcat.global_position = $AparecerCat.global_position
		
	if newcat.randability == 2:
	
		if randCat == 1:
			$AparecerCat.position = to_local(Vector2(self.position.x + randi_range(-500, -400), self.position.y ))
			$Indicador.position = $AparecerCat.position
		else:
			$AparecerCat.position = to_local(Vector2(self.position.x + randi_range(500, 400), self.position.y ))
			$Indicador.position = $AparecerCat.position
			
		newalert.global_position = Vector2($Indicador.global_position.x, -100)
		newcat.global_position = $AparecerCat.global_position
		
	if estagirado:
		newcat.get_node("Textura").flip_h = true
	else: 
		newcat.get_node("Textura").flip_h = false
		
	get_parent().add_child(newalert)
	get_parent().add_child(newcat)
	StageThreeCatList.append(newcat)
	StageThreelightList.append(newalert)

func aparcercarro():
		
	var newcar = car.instantiate()
	newcar.global_position = $CarAparecer.global_position
	newcar.scale = Vector2(0.9, 0.9)
	newcar.vida = 3
	newcar.modulate = Color(0.5,1,100)
	newcar.get_node("TexturaEnemigo").material.set("shader_parameter/ModulateShader" , Color(1, 1, 0.6))
	newcar.get_node("Luz").enabled = true

	get_parent().call_deferred("add_child", newcar)
