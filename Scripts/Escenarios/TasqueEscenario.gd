extends Node2D

var i : float = 0.0

var tasquefight = preload("res://Sonidos/Enemigos/OstEnemigos/Pandora Palace.wav")
var won = preload("res://Sonidos/Enemigos/DerrotarBoss.wav")
var apagon = preload("res://Sonidos/Enemigos/Sonido de apagón.wav")
var musica = preload("res://Sonidos/Ambientacion/Musica/CyberWorld.wav")
@export var gravedad = 5000

func _ready():
	pantallaCarga()
	_musica()

func pantallaCarga():
	Global.ultimaEscena = scene_file_path
	
func apagar():
	
	if $Iluminacion.energy <= 0.0:
		$Backgroundmusic.stream = apagon
		$Backgroundmusic.play()
			
func bossfight(jefe):
	$Backgroundmusic.volume_db = -5
	$Terreno/Fondo.visible = true
	$Terreno/Fondo.play("Pelea")
	$Backgroundmusic.volume_db = -10
	if jefe == "tasqueManager":
		$Backgroundmusic.stream = tasquefight
		
	$Backgroundmusic.play()


func bossfightend():

	$Terreno/Fondo.stop()
	$Terreno/Fondo.visible = false
	$Iluminacion.energy = 1
	$Backgroundmusic.stop()
	_musica()
	
func _musica():
	$Backgroundmusic.volume_db = -10
	$Backgroundmusic.stream = musica
	$Backgroundmusic.play()
