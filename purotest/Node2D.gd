extends Area2D


# Called when the node enters the scene tree for the first time.
var direction : Vector2 = Vector2.RIGHT
var speed : float = 300


func _physics_process(delta):
	position += direction * speed * delta


func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free()
