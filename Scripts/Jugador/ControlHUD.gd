extends Control

var saludJugador : int
#-------------------------------Enteros y Floats---------------------------#	
var tomarVida: int
var tomarVidaMax: int

var contador : int = 0
var textSalud = ['* Eso Dolio ', 
"* OYE!!!",
"* Hey!",
"* Auch "]

@onready var texto1 = $Canvas/Texto1
@onready var texto2 = $Canvas/Texto2
@onready var saltar = $Animacion


var estagiradoV : bool = false
var estaDisparandoV : bool = false
var cancelar : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Canvas.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	jugadorVida()
	jefeVida()
	
func jugadorVida():
		
	tomarVidaMax = $Canvas/BarraSalud.max_value
	tomarVida = $Canvas/BarraSalud.value
	
	texto1.text = str(tomarVida) + " / " + str(tomarVidaMax)

	if !cancelar:	
		$Canvas/expresiones.play("girado")
		if estagiradoV:
			$Canvas/expresiones.flip_h = false
		else:
			$Canvas/expresiones.flip_h = true
		if estaDisparandoV: 
			$Canvas/expresiones.play("Shoot")
				
	if tomarVida <= 0: $Canvas/expresiones.visible = true
			
	if $Canvas/ControlJefe/BossBar.value <= 0:
		$Canvas/ControlJefe.visible = false

func jefeVida():
	$Canvas/ControlJefe/VidaBoss.text = str($Canvas/ControlJefe/BossBar.value) + " / " + str($Canvas/ControlJefe/BossBar.max_value)

func mensaje():
	
	var random = randi_range(1,4)
	$voz.volume_db = -15
	$voz.play()
	cancelar = true
	if random == 1:
		$Canvas/Texto1.text = textSalud[0]
		$Canvas/expresiones.play("Angry")
		saltar.play("text")
		await $Canvas/expresiones.animation_finished
		$voz.playing = false
		cancelar = false
		texto2.visible_ratio = 0
	if random == 2: 
		$Canvas/Texto1.text  = textSalud[1]
		$Canvas/expresiones.play("Angry")
		saltar.play("text")
		await $Canvas/expresiones.animation_finished
		$voz.playing = false
		cancelar = false
		texto2.visible_ratio = 0
	if random == 3: 
		$Canvas/Texto1.text  = textSalud[2]
		$Canvas/expresiones.play("Angry")
		saltar.play("text")
		await $Canvas/expresiones.animation_finished
		$voz.playing = false
		cancelar = false
		texto2.visible_ratio = 0
	if random == 4: 
		$Canvas/Texto1.text  = textSalud[3]
		$Canvas/expresiones.play("Angry")
		saltar.play("text")
		await $Canvas/expresiones.animation_finished
		$voz.playing = false
		cancelar = false
		texto2.visible_ratio = 0

func estagirado():
	estagiradoV = true

func noestagirado():
	estagiradoV = false

func estadisparando():
	
	estaDisparandoV = true

func noestadisparando():
	
	estaDisparandoV = false

var yaHayBoss : bool = false
func bossBar(tipoEnemigo, vida, vidaTotal):
	
	if !yaHayBoss:
		$Canvas/ControlJefe.visible = true
		yaHayBoss = true
		if tipoEnemigo == "tasqueManager":
			$Canvas/ControlJefe/BossBar.max_value = vidaTotal
			$Canvas/ControlJefe/BossBar.value = vida
			$Canvas/ControlJefe/BossBar.self_modulate = "7effff"
			$Canvas/ControlJefe/BossLabel.text = "* Tasque Manager"


		
