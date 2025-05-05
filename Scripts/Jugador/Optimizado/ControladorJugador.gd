extends CharacterBody2D

@onready var disparo = preload("res://Escenas/Jugador/Disparo.tscn")
@onready var fogonazo = preload("res://Escenas/Miscelaneos/Ambiente/destello.tscn")

var colores = ["ff00ff","00ffff","ffff00","0000ff","ff0000"]

var gravedad : int
@export var dañoJugador : int = 2

@export var velocidad : int = 400
@export var potenciaSalto : int = -1000
@export var vida : int = 100
@export var vidaMaxima : int = 100

@export var potenciaDesplazamiento : int = 1500
var contadorDesplazamiento : float 
@export var cargasDesplazamiento : int = 0
@export var cargasMaximasDesplazamientos : int = 3
@export var tiempoParaDesplazamiento : float = 1

var contadorEscudo : float 
@export var tiempoParaEscudo : float = 1
var escudo : bool = false
@export var tiempoInvulnerableEscudo : float = 1
var contadorInvulnerableEscudo : float

@export var tiempoInvulnerableGolpe : float = 1
var contadorInvulnerableGolpe : float

var poder : bool = false
var haciendoPoder : bool = false

var desplazando : bool = false
var disparando : bool = false
var saltando : bool = false
var muriendo : bool = false
var golpeado : bool = false
var fueGolpeado : bool = false
var cubriendo : bool = false
var parry : bool = false

var dañoLetal = Vector2(0, -3000)

func _ready():
	contadorDesplazamiento = tiempoParaDesplazamiento
	gravedad = get_parent().gravedad
	$Textura.play("Quieto")

func _process(delta):
	
	if disparando and !golpeado:
		$HUD/Canvas/expresiones.play("Shoot")

	if $Textura.flip_h == false:
		$HUD/Canvas/expresiones.flip_h = true
	else:
		$HUD/Canvas/expresiones.flip_h = false
	_animaciones()
	if !muriendo:
		_vida()
		_estados(delta)
		_escudo(delta)
		_marcadores()
		if !golpeado:
			_desplazamiento(delta)
			_movimiento(delta)
			_disparo()
			_poder()
	
	move_and_slide()
	
func _movimiento(delta):
	if !is_on_floor() and !desplazando:
		velocity.y += gravedad * delta
	if !cubriendo:
		if !desplazando:
			if !disparando:
				if !haciendoPoder:
					
					if is_on_floor():
						fueGolpeado = false
						
					var direccion = Input.get_axis("a","d")
					
					if direccion:
						fueGolpeado = false
						
					if !fueGolpeado:
						velocity.x = direccion * velocidad
			if is_on_floor():
				if Input.is_action_pressed("w") and !haciendoPoder:
					disparando = false
					velocity.y = potenciaSalto 
					
func _desplazamiento(delta):
	$HUD/Canvas/BarraDesplazamiento.max_value = cargasMaximasDesplazamientos
	$HUD/Canvas/BarraDesplazamiento.value = cargasDesplazamiento
	
	if !cubriendo:
		if !desplazando:
			if Input.is_action_just_pressed("dash") and cargasDesplazamiento >= 1 and !haciendoPoder:
				desplazando = true
				cargasDesplazamiento -= 1
				velocity.y = 0
				if Input.is_action_pressed("a"):
					velocity.x = -potenciaDesplazamiento
				if Input.is_action_pressed("d"):
					velocity.x = potenciaDesplazamiento
				if !Input.is_action_pressed("d") and !Input.is_action_pressed("a"):
					if $Textura.flip_h:
						velocity.x = -potenciaDesplazamiento
					if !$Textura.flip_h:
						velocity.x = potenciaDesplazamiento
	

	if cargasDesplazamiento < cargasMaximasDesplazamientos:
		contadorDesplazamiento -= delta
		if contadorDesplazamiento <= 0.0:
			cargasDesplazamiento += 1
			contadorDesplazamiento = tiempoParaDesplazamiento
	
func _animaciones():
	
	if !muriendo or !golpeado:
		if cubriendo and !golpeado:
			$Escudo/Colision.disabled = false
			velocity = Vector2.ZERO
			$Textura.play("Cobertura")
			await $Textura.animation_finished
			cubriendo = false
			$Escudo/Colision.disabled = true

		if haciendoPoder and !golpeado:
			
			$PoderLuz.enabled = true
			var random = randf_range(0.2,0.05)
			$PoderLuz.scale = Vector2(random,random)
			velocity.x = 0
			$Textura.play("Poder")
			await $Textura.animation_finished
			haciendoPoder = false
			$PoderLuz.enabled = false
			
		if desplazando  and !golpeado:
			$Textura.play("Desplazamiento")
			await $Textura.animation_finished
			desplazando = false
			
		if !golpeado:
			if disparando and !golpeado:
				velocity.x = 0
				$Textura.play("Disparo")
				await $Textura.animation_finished
				disparando = false
		
		if !desplazando or !disparando or !haciendoPoder or !golpeado:
			if velocity.x != 0 and velocity.y == 0:
				$Textura.play("Caminar")
			if velocity.x == 0 and velocity.y == 0:
				$Textura.play("Quieto")
			if velocity.y != 0:
				saltando = true
				$Textura.play("Salto")
			else:
				saltando = false
				
		if velocity.x < -1:
			$Textura.flip_h = true
		if velocity.x > 1:
			$Textura.flip_h = false

func _disparo():
	if is_on_floor():
		if !disparando and !desplazando and !haciendoPoder and !cubriendo:
			if Input.is_action_just_pressed("golpe"):
				$Sonido.disparo()
				var disparoNuevo = disparo.instantiate()
				var fogonazoNuevo = fogonazo.instantiate()
				
				disparoNuevo.dañoJugador = dañoJugador
				if parry:
					disparoNuevo.dañoJugador = dañoJugador * 5
				else:
					disparoNuevo.dañoJugador = dañoJugador
				if $Textura.flip_h:
					disparoNuevo.velocidad = -400
					disparoNuevo.global_position = $Disparo.global_position
					disparoNuevo.scale = Vector2(-0.5,0.5)
				if !$Textura.flip_h:
					disparoNuevo.velocidad = 400
					disparoNuevo.global_position = $Disparo.global_position
					disparoNuevo.scale = Vector2(0.5,0.5)
				
				fogonazoNuevo.global_position = disparoNuevo.global_position
				get_parent().add_child(fogonazoNuevo)
				get_parent().add_child(disparoNuevo)
				disparando = true

func _marcadores():
	if $Textura.flip_h:
		$Disparo.position = Vector2(-110,3)
	if !$Textura.flip_h:
		$Disparo.position = Vector2(100,3)

func _vida():
	$HUD/Canvas/BarraSalud.max_value = vidaMaxima
	$HUD/Canvas/BarraSalud.value = vida
	if $HUD/Canvas/BarraSalud.value <= 0:
		_muerte()

func _golpe(dañoEnemigo,empujeEnemigo,tipoEnemigo):
	golpeado = true
	fueGolpeado = true
	$Sonido.daño(tipoEnemigo)
	$HUD.mensaje()
	vida -= dañoEnemigo
	velocity = empujeEnemigo
	$Textura.play("hit")
	await $Textura.animation_finished
	golpeado = false

func _muerte():
	muriendo = true
	velocity = dañoLetal
	$Colision.disabled = true
	$Textura.play("Morir")
	await $Textura.animation_finished
	get_tree().change_scene_to_file("res://Escenas/Menus/Gameover.tscn")

func _poder():
	if $HUD/Canvas/BarraPoder.value >= 100:
		poder = true
	else:
		poder = false
	
	if poder and Input.is_action_just_pressed("habilidad") and !haciendoPoder:
		haciendoPoder = true
		await $Textura.animation_finished
		if golpeado:
			$HUD/Canvas/BarraPoder.value = 50
			vida += 5
			haciendoPoder = false
		else:
			vida += 30
			$HUD/Canvas/BarraPoder.value = 0
	
func _cargarPoder():
	$HUD/Canvas/BarraPoder.value += 10

func _escudo(delta):

	if contadorEscudo > 0.0:
		contadorEscudo -= delta

	if is_on_floor() and contadorEscudo <= 0.0 and !parry and contadorInvulnerableGolpe <= 0.0 and !haciendoPoder:
		escudo = true
	else:
		escudo = false
		
	if escudo:
		$HUD/Canvas/BarraEscudo.value = 1
	else:
		$HUD/Canvas/BarraEscudo.value = 0
	
	if Input.is_action_just_pressed("defensa") and !cubriendo and escudo :
		cubriendo = true
		contadorEscudo = tiempoParaEscudo

func _parry(body):
	parry = true
	contadorInvulnerableEscudo = tiempoInvulnerableEscudo
	$Escudo/Colision.call_deferred("is_disabled")
	$Sonido.bloqueo()
	if body.is_in_group("enemigo"):
		body.segundosInactivos = 1.5
		body.hit = true
		vida += 5
	if body.is_in_group("proyectil"):
		body.get_parent().get_parent().queue_free()
		vida += 5

func _estados(delta):
	
	if cubriendo:
		$Escudo/Colision.disabled = false
	else:
		$Escudo/Colision.disabled = true
		
	if golpeado:
		contadorInvulnerableGolpe = tiempoInvulnerableGolpe
#
	if contadorInvulnerableEscudo > 0.0:
		parry = true
		contadorInvulnerableEscudo -= delta
		if contadorInvulnerableEscudo <= 0.0:
			parry = false

	if parry:
		$Luz.enabled = true
		$Textura.modulate = colores[randi_range(0,4)]
		$Textura.speed_scale = 1.5
		velocidad = 600
		potenciaSalto = -1200
	else:
		$Textura.speed_scale = 1
		$Luz.enabled = false
		$Textura.modulate = "ffffff"
		parry = false
		velocidad = 400
		potenciaSalto = -1000
	
	if contadorInvulnerableGolpe > 0.0 or desplazando or cubriendo or parry:
		
		if contadorInvulnerableGolpe > 0.0:
			contadorInvulnerableGolpe -= delta
			$Animacion.play("Parpadeo")
					
		collision_layer = 16
	else:
		$Animacion.stop()
		collision_layer = 1
