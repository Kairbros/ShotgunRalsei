extends PointLight2D

var tiempo: float = 0.5
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	tiempo -= delta
	
	if tiempo <= 0:
		queue_free()
	
		
