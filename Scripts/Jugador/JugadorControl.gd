extends CharacterBody2D

@onready var bala = preload("res://Escenas/Jugador/Disparo.tscn")
@onready var destello = preload("res://Escenas/Miscelaneos/Ambiente/destello.tscn")
@onready var powerup  = preload("res://Shader/pariculas/powerupParticles.tres")
@onready var powerupParticle  = preload("res://Sprites/Particulas/starparticle.png")

var colores = ["ff00ff","00ffff","ffff00","0000ff","ff0000"]

var habilidadCargada : bool = false
var hitJugador: bool = false
var hitAire : bool = false
var estaAtacando : bool = false
var salto : bool = false
var ultimate : bool = false
var gesto : bool = false
var estaEnDash : bool = false
var invulnerable : bool = false
var parryBuff : bool = false
var particula: bool = false

# Variables 
@export var dañoJugador : int = 1
@export var distanciaDash : int = 1500
@export var tiempoBuff : float = 1.5
@export var vida: int = 100
@export var vidaMaxima : int = 100
@export var tiempoDash : float = 0.7

# Variables Auxilares
var guardarTiempoBuff : float  
var ContadorDash  : float 
var tiempoInvulnerable : float = 0
var charge : int = 1

# Variables Movimientos
var velocidad = 400
var potenciaSalto = -1000
var dañoLetal = Vector2(0, -3000)
var gravedad : int

func _ready():
	ContadorDash = tiempoDash
	barraVida()
	gravedad = get_parent().gravedad
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$HUD/Canvas/PowerBar.value  = 0
	$Textura.play("default")

func barraVida():
	$HUD/Canvas/BarraSalud.max_value = vidaMaxima
	$HUD/Canvas/BarraSalud.value = vida
	
func _physics_process(delta):
	
	shaderController(delta)
	dashController(delta)
	defensaController(delta)
	_volver()

	if parryBuff:
		$Luz.enabled = true
		$Textura.modulate = colores[randi_range(0,4)]
		$Textura.speed_scale = 1.5
		collision_layer = 16
		velocidad = 600
		potenciaSalto = -1200
		tiempoBuff -= delta
		if tiempoBuff <= 0.0:
			tiempoBuff = guardarTiempoBuff
			$Textura.speed_scale = 1
			$Luz.enabled = false
			$Textura.modulate = "ffffff"
			parryBuff = false
			velocidad = 400
			potenciaSalto = -1000
			collision_layer = 1


		#-------------------------------Codigo Animaciones---------------------------#z
	if !estaEnDash:
		if !hitJugador:
			saltar()
			if !estaAtacando:
				fumar()
				if !gesto and !cubriendo:
					animaciones()
					movimiento(delta)
					atacar()
					curar()
			#-------------------------------movimiento---------------------------#	
			
	HUDController()
	move_and_slide()

func HUDController():
	
	if $Textura.flip_h:
		$Textura/PowerLight.position.x = -15
		$HUD.estagirado()
	else:
		$Textura/PowerLight.position.x = 15 
		$HUD.noestagirado()

	if estaAtacando == true:
		$HUD.estadisparando()
	else:
		$HUD.noestadisparando()

func dashController(delta):

	if estaEnDash or cubriendo or invulnerable:
		collision_layer = 16
	else:
		collision_layer = 1
		
	if invulnerable:
		tiempoInvulnerable -= delta
		if tiempoInvulnerable <= 0:
			invulnerable = false
			
			
	ContadorDash += delta
	if ContadorDash >= tiempoDash:
		ContadorDash = tiempoDash
		
	if is_on_floor():
		charge = 1
		
	if charge == 1 and $HUD/Canvas/BarraSalud.value != 0 and ContadorDash >= tiempoDash and !ultimate and !hitJugador:
		dash()
		$HUD/Canvas/DashBar.contador()
	else:
		$HUD/Canvas/DashBar.descontador()

func fumar():
	if !is_on_floor() or velocity != Vector2.ZERO:
		gesto = false
	if velocity == Vector2.ZERO and Input.is_action_pressed("taunt"):
		gesto = true
		velocity.x = 0
		$Textura.play("taunt")
	if !Input.is_action_pressed("taunt"):
		gesto = false
	
	if gesto == true:
		$Textura/PowerLight.enabled = true
		$Textura/PowerLight.scale = Vector2(randf_range(0.01,0.05),randf_range(0.01,0.05))
		if 	$HUD/Canvas/BarraSalud.value <= 10:
			$HUD/Canvas/BarraSalud.value += 0.5
		else:
			pass
	else:
		$Textura/PowerLight.enabled = false

func animaciones():
	
	if !is_on_floor():
		$Textura.play("caida")
		if Input.is_action_pressed("a"):
			$Textura.flip_h = true
		if Input.is_action_pressed("d"):
			$Textura.flip_h = false
		
	if Input.is_action_pressed("a") and !salto:
		$Textura.flip_h = true
		$Textura.play("caminar")
	if Input.is_action_pressed("d") and !salto:
		$Textura.play("caminar")
		$Textura.flip_h = false
	if velocity == Vector2.ZERO:
		$Textura.play("default")

func shaderController(_delta):
		
	if velocity != Vector2.ZERO:
		$Particulas/PowerLight.enabled = false
		$Textura/PowerLight.enabled = false
	if ultimate:
		var random =  randf_range(0.01,0.2)
		$Particulas/PowerLight.enabled = true
		$Particulas/PowerLight.scale = Vector2(random,random)
	else:
		$Particulas/PowerLight.enabled = false
		
	if particula == false:
		$Particulas.emitting = false


	if ultimate:
		particula = true
		$Particulas.emitting = true
		$Particulas.amount = 10
		$Particulas.texture = powerupParticle
		$Particulas.process_material = powerup
	
	else:
		particula = false

		
		
	$Textura.material = ShaderMaterial.new()
	if tiempoInvulnerable > 0.0:
		$Animacion.play("Parpadeo")

	if  tiempoInvulnerable < 0.0: 
		$Animacion.stop()
	
func hit(dañoEnemigo, empujeEnemigo, tipoEnemigo):
	
	invulnerable = true
	tiempoInvulnerable = 1.5
	$HUD.mensaje()
	hitJugador = true
	hitAire = true
	velocity = empujeEnemigo
	$Textura.play("hit")
	$HUD.disminuirVida(dañoEnemigo)
	get_node("Sonido").daño(tipoEnemigo)
	await $Textura.animation_finished
	hitJugador = false

func dead():
	velocity = dañoLetal
	$Textura.play("morir")
	$Colision.queue_free()
	await $Textura.animation_finished
	get_tree().change_scene_to_file("res://Escenas/Menus/Gameover.tscn")
	
func disparo():
	
	var nuevaBala = bala.instantiate() #instancia, llama a un objeto de otra clase
	var nuevoDestello = destello.instantiate()
	

	if parryBuff:
		nuevaBala.dañoJugador = dañoJugador * 5
	else:
		nuevaBala.dañoJugador = dañoJugador
		
	if $Textura.flip_h:
		nuevoDestello.get_node("Luz").position.x = -60
		nuevaBala.velocidad = -400

		$Disparo/Direccion.position.x = - 10 #manda la velocidad al otro elemento, se necesita que este creado en la clase original
	else:
		nuevoDestello.get_node("Luz").position.x = 60

		nuevaBala.velocidad = 400

		$Disparo/Direccion.position.x = 10
	
	nuevaBala.global_position = $Disparo/Direccion.global_position #toma posicion del objeto y la remplaza por la posicion del otro elemento
	get_parent().add_child(nuevaBala) #añade al nodo padre el objeto
	nuevoDestello.global_position = $Disparo/Direccion.global_position
	get_parent().add_child(nuevoDestello)

func dash():
	
	
	if Input.is_action_just_pressed("dash") :
		charge = 0
		ContadorDash = 0.0
		estaEnDash = true
		if $Textura.flip_h and !Input.is_action_pressed("d"):
			velocity.y = 0
			velocity.x = -distanciaDash
			$Textura.play("dash")
			await $Textura.animation_finished
			estaEnDash = false
		if $Textura.flip_h and Input.is_action_pressed("d"):
			velocity.y = 0
			velocity.x = distanciaDash
			$Textura.play("dash")
			await $Textura.animation_finished
			estaEnDash = false
		if !$Textura.flip_h and !Input.is_action_pressed("a"):
			velocity.y = 0
			velocity.x = distanciaDash
			$Textura.play("dash")
			await $Textura.animation_finished
			estaEnDash = false
		if !$Textura.flip_h and Input.is_action_pressed("a"):
			velocity.y = 0
			velocity.x = -distanciaDash
			$Textura.play("dash")
			await $Textura.animation_finished
			estaEnDash = false
			
func curacion():
	
	$HUD/Canvas/BarraSalud.value += 40

func aumento():

	if $HUD/Canvas/PowerBar.value == 100:
		habilidadCargada = true

func atacar():

	if Input.is_action_just_pressed("golpe") and !salto:
				estaAtacando = true
				disparo()
				get_node("Sonido").disparo()
				if estaAtacando == true:
					velocity = Vector2.ZERO
				$Textura.play("ataque")
				await $Textura.animation_finished
				estaAtacando = false

func curar():
	if Input.is_action_just_pressed("habilidad") and !salto and habilidadCargada:
				estaAtacando = true
				ultimate = true
				if estaAtacando == true:
					velocity = Vector2.ZERO
				$Textura.play("carga")
				await $Textura.animation_finished
				if hitJugador:
					$HUD/Canvas/PowerBar.value = 50
					habilidadCargada = false
				else: 
					$HUD/Canvas/PowerBar.value = 0
					habilidadCargada = false
					curacion()
				estaAtacando = false
				ultimate = false
				habilidadCargada = false

func movimiento(delta):
	
	if is_on_floor():
		hitAire = false
		velocity.x = 0
		salto = false
		
	if !is_on_floor():
		salto = true
		velocity.y += delta *gravedad
		
	var direction = Input.get_axis("a", "d")
	
	if direction and !hitJugador:
		velocity.x = direction * velocidad
	elif !hitAire:
		velocity.x = 0

func saltar():
	
	if Input.is_action_pressed("w") and is_on_floor() and !ultimate and !gesto:
		$Textura.play("caida")
		estaAtacando = false

		velocity.y = potenciaSalto
var cubriendo :bool = false

var cdParry : float = 2.5

func defensaController(delta):
	
	cdParry += delta
	if cdParry >= 2.5:
		cdParry = 2.5
		
	if $HUD/Canvas/BarraSalud.value != 0 and cdParry >= 2.5 and !ultimate and !hitJugador and !salto and !invulnerable and !parryBuff :
		$HUD/Canvas/ParryBar.contador()
		defensa()
	else:
		$HUD/Canvas/ParryBar.descontador()
		
	if cubriendo:
		$Escudo/Colision.disabled = false
	else:
		$Escudo/Colision.disabled = true
		
func defensa():
	

	if velocity != Vector2.ZERO:
		cubriendo = false
	if Input.is_action_just_pressed("defensa")  :
		cdParry = 0.0
		cubriendo = true
		velocity = Vector2.ZERO
		$Textura.play("defensa")
		await  $Textura.animation_finished
		cubriendo = false
	
func _on_escudo_body_entered(body):
	guardarTiempoBuff = tiempoBuff
	parryBuff = true
	$Escudo/Colision.call_deferred("is_disabled")
	$Sonido.bloqueo()
	if body.is_in_group("enemigo"):
		body.segundosInactivos = 1.5
		body.hit = true
		$HUD/Canvas/BarraSalud.value += 5
	if body.is_in_group("proyectil"):
		body.get_parent().get_parent().queue_free()
		$HUD/Canvas/BarraSalud.value += 5
	
func _volver():
	if Input.is_action_just_pressed("ESC"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		Global.nuevaEscena = "res://Escenas/Menus/Menu.tscn"
		get_tree().change_scene_to_file("res://Escenas/Menus/PantallaCarga/Pantallacarga.tscn")
		
