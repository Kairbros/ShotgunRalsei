extends CharacterBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
var dañoEnemigo : int = 99999999999
var empujeEnemigo = Vector2(0, -3000)
var tipoEnemigo : String = "plataforma"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_area_muerte_body_entered(body):
	body._golpe(dañoEnemigo, empujeEnemigo, tipoEnemigo)
