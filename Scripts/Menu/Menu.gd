extends Node2D

var select = preload("res://Sonidos/Menu/Select.wav")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.


func _on_boton_inicio_pressed():
#	$Sonido.stream = select
#	$Sonido.play()
	pass
	get_tree().change_scene_to_file("res://Escenas/Menus/Niveles.tscn")



func _on_boton_inicio_2_pressed():
#	$Sonido.stream = select
#	$Sonido.play()
	pass
	get_tree().quit()



func _on_boton_inicio_mouse_entered():
	$Sonido.stream = select
	$Sonido.play()


func _on_boton_salida_mouse_entered():
	$Sonido.stream = select
	$Sonido.play()


func _on_link_button_mouse_entered():
	$Sonido.stream = select
	$Sonido.play()


func _on_link_button_pressed():
	$Sonido.stream = select
	$Sonido.play()
