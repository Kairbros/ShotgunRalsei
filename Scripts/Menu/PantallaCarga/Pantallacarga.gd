extends Control


var progreso : Array	
var estadoCarga : int
# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = false
	ResourceLoader.load_threaded_request(Global.nuevaEscena)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	estadoCarga = ResourceLoader.load_threaded_get_status(Global.nuevaEscena, progreso)
	$Carga.value = progreso[0]*100
	
	
	
func _on_carga_value_changed(value):
	
	if $Carga.value == 100 and estadoCarga == ResourceLoader.THREAD_LOAD_LOADED:
		get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(Global.nuevaEscena))
