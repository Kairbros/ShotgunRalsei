extends Area2D


# Called when the node enters the scene tree for the first time.

var velocidad : int
var yaNoSeguir : bool = false
var dañoJugador : int
var impacto : bool = false
@onready var jugador = get_parent().get_node("Jugador")

func _ready():
	$Textura.play("Fogonazo")

func _process(delta):
	$Colision.global_position.x += velocidad *delta #toma la posicion y la multiplica por la velocidad
	
	if jugador.velocity != Vector2.ZERO:
		yaNoSeguir = true
	
	if !yaNoSeguir:
		global_position = jugador.get_node("Disparo").global_position
	$Luz.global_position = $Textura.global_position

	
	await $Textura.animation_finished
	queue_free()

func _impacto(body):
	if body.is_in_group("enemigo"):
		impacto = true
		$Colision.set_deferred("disabled", true)
		body._hit(dañoJugador)
		get_parent().get_node("Jugador")._cargarPoder() #le dice a el primer objeto de un grupo que funcion ejecutar
		await $Textura.animation_finished
		queue_free()
	else: 
		$Colision.set_deferred("disabled", true)

		await $Textura.animation_finished
		queue_free() #elimina el objeto
