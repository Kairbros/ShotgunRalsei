extends CharacterBody2D

@onready var textura = $TexturaEnemigo
var jugador 
var terrenofrente: bool = false
@export var dañoEnemigo : int = 30
@export var tipoEnemigo: String = "Carro"
@export var empujeEnemigo = Vector2( 800, -150)
@export var empuje = Vector2(0, -500)
@export var salto = Vector2(-100, -100)

var jugadorC
var velocidad : int = 100

var velperseguir: int = 400
var velsalto: int = 1300

var saltoH : int = -1000
var hit : bool
var gravedad =5000
var segundos :float

# Get the gravity from the project settings to be synced with RigidBody nodes
# Moves right if facing right, and left if facing left 
# based on the root node's scale

func _ready():
	jugadorC = get_parent().find_child("Player")
	velocity.x = velocidad
	
func _physics_process(delta):

	if estacerca:
		if $TexturaEnemigo.flip_h:
			$WallDetector/CollisionShape2D.position.x = -50
		else: $WallDetector/CollisionShape2D.position.x = 50
	
	if !estacerca:
		if $TexturaEnemigo.flip_h:
			$WallDetector/CollisionShape2D.position.x = -150
		else: $WallDetector/CollisionShape2D.position.x = 150

	if is_on_wall() and !perseguir:
		if !$TexturaEnemigo.flip_h:
			velocity.x = -velocidad
		elif !perseguir: 
			velocity.x = velocidad

	if not is_on_floor():
		$TexturaEnemigo.play("HitEnemi")
		velocity.y += gravedad*delta
		
	if velocity.y == 0:
		hit = false
	direcciones()
			
	if !hit:
		
		velocity.x = 0
		if is_on_floor():
			hit = false
			textura.play("walk")
		
		if segundos <= 0:
			$"AreaDaño/CollisionShape2D".disabled = false
			if jugador:
				$DetectarT.target_position = to_local(jugador.position)
				if $DetectarT.get_collider() == jugadorC:
					perseguir = true
					if self.position < jugador.position:
						velocity.x = velperseguir
						if !is_on_floor() and perseguir == true:
							velocity.x = velsalto
					elif self.position > jugador.position:
						velocity.x = -velperseguir
						if !is_on_floor() and perseguir == true:
				
							velocity.x = -velsalto
			else: perseguir = false
				
				
			if velocity.x == 0 and $TexturaEnemigo.flip_h == true:
				velocity.x = -velocidad
			elif velocity.x == 0 and $TexturaEnemigo.flip_h == false:
				velocity.x = velocidad
				


		else:
			segundos -= delta
		
			velocity.x = 0
			$"AreaDaño/CollisionShape2D".disabled = true
	
	move_and_slide()



func direcciones():
	
	if velocity.x > 0:
		textura.flip_h = false
	elif velocity.x < 0: textura.flip_h = true
	
var numeroimpA : int = 0
@export var vida: int = 6
func dead(numeroimp):
	numeroimpA = numeroimpA + numeroimp
	if numeroimpA == vida:
		$ColisionEnemigo.queue_free() #Elimina el colisionador pero no se porque
		$AreaDaño/CollisionShape2D.queue_free()
		set_physics_process(false) #Paraliza las fisicas
		$TexturaEnemigo.play("death") #Inicia animacion
		await ($TexturaEnemigo.animation_finished) #esperar a que la animacion termine
		queue_free() #elimina el objeto
	else: 
		hit = true
		segundos = 0.3
		velocity = Vector2.ZERO
		velocity = empuje
	
		
	
func _on_area_2d_body_entered(body):
	
	if body.is_in_group("jugador") and $TexturaEnemigo.flip_h == true:
		body.hit2(dañoEnemigo, empujeEnemigo, tipoEnemigo)
		segundos = 1.5
	if body.is_in_group("jugador") and $TexturaEnemigo.flip_h == false:
		body.hit(dañoEnemigo, empujeEnemigo, tipoEnemigo)
		segundos = 1.5



var perseguir : bool

func _on_area_deteccion_body_entered(body):
	

	jugador = body



func _on_area_deteccion_body_exited(body):
	
	jugador = null


func _on_ground_detecter_body_exited(body):
	
	if !perseguir:
		velocity.x = -velocidad
	
	if perseguir == true and is_on_floor():
		velocity.y = -1000


func _on_ground_detecter_l_body_exited(body):
	
	if !perseguir:
		velocity.x = velocidad
	
	if perseguir == true and is_on_floor()	:
		velocity.y = -1000
 

func _on_wall_detector_body_entered(body):
	
	if perseguir and is_on_floor():
		velocity.y = -1300
	

var estacerca 
func _on_activar_salto_body_entered(body):
	estacerca = body


func _on_activar_salto_body_exited(body):
	estacerca = null
	pass # Replace with function body.
