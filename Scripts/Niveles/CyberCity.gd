extends Node

@onready var car = preload("res://Escenas/Enemigos/Terrestres/DogCar.tscn")

var estaEnPuerta : bool = false
var direccion : PackedScene
var plip = preload("res://Sonidos/Menu/Select.wav")
var tasqueBoss = preload("res://Escenas/juego_test.tscn")
var listaEnemigos : Array

var segundos : float = 5

func _process(delta):

		
	if listaEnemigos.size() <= 5:
		segundos -= delta
		if segundos <= 0:
			segundos = 5
			aparecerEnemigo()
		
	if estaEnPuerta :
		if Input.is_action_pressed("ui_up"):
			get_tree().change_scene_to_packed(direccion)
	
func _on_entrada_body_entered(body):
	
	
	for i in range(listaEnemigos.size()):
		if body.is_in_group("jugador") and listaEnemigos.size() >= 5 and listaEnemigos[i] == null:
			$Backgroundmusic.stream = plip
			$Backgroundmusic.play()
			estaEnPuerta = true
			direccion = tasqueBoss
		
func _on_entrada_body_exited(_body):
	estaEnPuerta = false
	direccion = null

func aparecerEnemigo():
	
	
	var newEnemigo = car.instantiate()
	
	newEnemigo.global_position = Vector2(get_node("Player").global_position.x - 400, get_node("Player").global_position.y )
	listaEnemigos.append(newEnemigo)
	get_parent().add_child(newEnemigo)
