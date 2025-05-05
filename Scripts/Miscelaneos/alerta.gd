extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Sonido.playing = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

#
#	$TimeSprite.play("default")
#	await $TimeSprite.animation_finished
#	queue_free()
