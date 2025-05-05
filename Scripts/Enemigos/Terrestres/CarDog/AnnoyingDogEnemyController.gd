extends CharacterBody2D

@onready var textura = $Textura
@export var dañoEnemigo : int = 30
@export var tipoEnemigo: String = "Carro"
@export var empujeEnemigo = Vector2( 800, -150)
@export var empuje = Vector2(0, -300)
#var parpadeo  = preload("res://Shader/Parpadeo.tres")



@export var vida: int = 6
var dañoJugadorA : int = 0

var estaCerca: bool = false
var estaEnBorde : bool = false
var hit : bool
var estaPersiguiendo : bool = false
var muriendo : bool = false

var jugador 

var segundosInactivos :float
var gravedad : int
var velocidad : int = randi_range(350, 450) 

func _ready():
	gravedad = get_parent().gravedad
	velocity.x = velocidad
	
func _physics_process(delta):

	if hit:
		segundosInactivos -= delta
		
		if segundosInactivos <= 0:
			hit = false
	
	if !is_on_floor() and !muriendo:
		velocity.y += gravedad * delta 
	if jugador:
		estaPersiguiendo = true
		$DetectarT.target_position = to_local (jugador.position)
		if $DetectarT.is_colliding():
			estaPersiguiendo = false
	else:
		$DetectarT.target_position = Vector2(0,0)
		estaPersiguiendo= false
		


	shaderController()
	movimiento()
	direcciones()
	move_and_slide()

func shaderController():
	
	if muriendo:
		$Animacion.play("Morir")
		$Textura.play("cooldown") #Inicia animacion
		await ($Animacion.animation_finished) #esperar a que la animacion termine
		queue_free() #elimina el objeto
		
#		var fade = $Textura.material.get("shader_parameter/fade")
#		$Textura.material.set("shader_parameter/fade" , fade - 0.050)
		pass
	else:
#		$Textura.material.shader = desaparecer # mierda importante
		pass


	if hit and !muriendo:
		$Animacion.play("Parpadeo")
		$AreaActivadora/Colision.disabled = true
#		$Textura.material.shader = parpadeo
	elif !muriendo: 
		$Animacion.stop()
		$AreaActivadora/Colision.disabled = false

func movimiento():
	
	if estaPersiguiendo and !hit:
		$Textura.play("walk")
		if self.position < jugador.position:
			velocity.x = velocidad
		elif self.position > jugador.position:
			velocity.x = -velocidad
		if estaCerca or estaEnBorde:
			velocity.x = 0
	else:
		$Textura.play("cooldown")
		velocity.x = 0

func direcciones():
	
	if velocity.x > 0:
		$DetectorPiso.position.x = 46
		$AreaActivadora/Colision.position.x = -245
		textura.flip_h = false
	elif velocity.x < 0:
		$AreaActivadora/Colision.position.x = 245
		$DetectorPiso.position.x =  -46
		textura.flip_h = true

func _hit(dañoJugador):
	dañoJugadorA = dañoJugadorA + dañoJugador
	if dañoJugadorA >= vida:
		$Luz.enabled = false
		muriendo = true
		$ColisionEnemigo.queue_free() #Elimina el colisionador pero no se porque
		$AreaDaño/Colision.queue_free()
		$AreaDeteccion/Colision.queue_free()
#		set_physics_process(false) #Paraliza las fisicas
	
	else: 
		hit = true
		segundosInactivos = 0.7
		velocity = Vector2.ZERO
		velocity = empuje
	

func _on_area_deteccion_body_entered(body):
	jugador = body
func _on_area_deteccion_body_exited(_body):
	jugador = null


func _on_area_activadora_body_entered(_body):
	estaEnBorde = false

func _on_cerca_body_entered(_body):
	estaCerca = true
func _on_cerca_body_exited(_body):
	estaCerca = false

func _on_detector_piso_body_entered(_body):
	estaEnBorde = false
	
func _on_detector_piso_body_exited(_body):
	estaEnBorde = true


func _on_area_daño_body_entered(body):
	hit = true
	segundosInactivos = 1.2
	if body.is_in_group("jugador") and $Textura.flip_h == true:
		body._golpe(dañoEnemigo, Vector2(-empujeEnemigo.x, empujeEnemigo.y), tipoEnemigo)

	if body.is_in_group("jugador") and $Textura.flip_h == false:
		body._golpe(dañoEnemigo, empujeEnemigo, tipoEnemigo)
