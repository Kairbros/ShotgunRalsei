extends Node2D

var acabo :bool = false
var palabras = ["No te rindas... 
aun puedes volverlo a intentar", 
"Vamos...
Intentalo una vez mas",
"Levantate..."]
var corazonEffect = preload("res://Sonidos/GameOver/UndertaleEffectGameOver.wav")
var GameOverMusic = "res://Sonidos/GameOver/UndertaleSongGameOver.wav"
@onready var reproductor = $Soundtrack
var contador : float
var finDialogo : bool = false
var segundero : float
var numero : int
var quit : bool
var reset : bool
# Called when the node enters the scene tree for the first time.


func _ready():
	pantallaCarga()
	$RalsVoz.volume_db = -10
	$Soundtrack.volume_db = 0
	reproductor.stream = corazonEffect
	$Soundtrack.play()
	$corazon.play("romper")
	$Control.modulate.a8 = 0
	await $corazon.animation_finished
	$Soundtrack.volume_db = -15
	$Control/CharacterBody2D.position = Vector2(0,0)
	$Corazon.queue_free()
	acabo = true
	if acabo:
		var reproducirMusica = load(GameOverMusic)
		reproductor.stream = reproducirMusica
		$Soundtrack.play()
		
func pantallaCarga():
	Global.nuevaEscena = Global.ultimaEscena

func  _process(delta):
	

	segundero += delta

	
	if acabo:
	
		contador += delta  * 100
		$Control.modulate.a8 = contador
		if segundero > 5:
			get_node("RalsVoz").habla()
			segundero = 0
	
	if reset:
		if Input.is_action_pressed("golpe"):
			get_tree().change_scene_to_file("res://Escenas/Menus/PantallaCarga/Pantallacarga.tscn")
	if quit:
		if Input.is_action_pressed("golpe"):
			get_tree().change_scene_to_file("res://Escenas/Menus/Menu.tscn")

		

func habla(si):
	numero += si
	
	if numero == 1:
		$RalsVoz.playing = true
		$Control/Game3.text = palabras[0]
		$texto.play("text")
		await $texto.animation_finished
		$RalsVoz.playing = false
		$texto.play("textback")
		await $texto.animation_finished
	
	
	if numero == 3:
		$RalsVoz.playing = true
		$Control/Game3.text = palabras[1]
		$texto.play("text")
		await $texto.animation_finished
		$RalsVoz.playing = false
		$texto.play("textback")
		await $texto.animation_finished
		
		
	if numero == 5:
		$RalsVoz.playing = true
		$Control/Game3.text = palabras[2]
		$texto.play("text")
		await $texto.animation_finished
		$RalsVoz.playing = false
		$texto.play("textback")
		await $texto.animation_finished
		numero = -10


func _on_area_2_body_entered(body):
	
	if body.is_in_group("corazon"):
		$Control/Menu2.modulate = "eada8c"
		reset = false
		quit = true

func _on_area_1_body_entered(body):
	
	if body.is_in_group("corazon"):
		$Control/Menu.modulate = "eada8c"
	reset = true
	quit = false
		
	pass # Replace with function body.


func _on_area_1_body_exited(_body):
	$Control/Menu.modulate = "616161"
	reset = false
	quit = false


func _on_area_2_body_exited(_body):
	$Control/Menu2.modulate = "616161"
	reset = false
	quit = false
