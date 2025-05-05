extends Node2D


# Called when the node enters the scene tree for the first time.

var velocidad : int

@export var dañoEnemigo : int = 15
@export var tipoEnemigo: String = "Gato"
@export var empujeEnemigo = Vector2( 300, -300)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	z_index = -1
	await $Animacion.animation_finished
	queue_free()


func _on_tasque_attack_body_entered(body):
	
	if body.is_in_group("jugador"):
		if  body.position > self.position:
			body._golpe(dañoEnemigo, empujeEnemigo, tipoEnemigo)
		else: 
			body._golpe(dañoEnemigo, Vector2(-empujeEnemigo.x, empujeEnemigo.y), tipoEnemigo)
		queue_free()
		


