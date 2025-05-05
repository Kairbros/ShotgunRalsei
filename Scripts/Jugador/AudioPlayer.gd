extends AudioStreamPlayer
var escopetazo = "res://Sonidos/Jugador/Ataque.wav"
var hit = load("res://Sonidos/HitSound.wav")
var parry = load("res://Sonidos/Jugador/Parry.wav")
## Called when the node enters the scene tree for the first time.


func caminar():
	pass
#	var sonidocaminar = load(caminata)
#	stop()
#	stream = sonidocaminar
#	play()
#
#

func daño(_tipoenemigo):
	self.volume_db =  -5
	
	stream = hit
	play()
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func disparo():
	
	self.volume_db = -5
	var sonidoescopetazo = load(escopetazo)
	stream = sonidoescopetazo
	play()
	
func bloqueo():
	
	self.volume_db = -10
	stream = parry
	play()

