extends Node2D

var select = preload("res://Sonidos/Menu/Select.wav")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_tasque_pressed():
	$Sonido.stream = select
	$Sonido.play()
	
	Global.nuevaEscena = "res://Escenas/TasqueEscenario.tscn"
	get_tree().change_scene_to_file("res://Escenas/Menus/PantallaCarga/Pantallacarga.tscn")
	


func _on_tasque_mouse_entered():
	$Sonido.stream = select
	$Sonido.play()
