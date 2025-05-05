extends CharacterBody2D


const SPEED = 2000.0


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(_delta):
	
	var lateral = Input.get_axis("ui_left", "ui_right")
	var vertical = Input.get_axis("ui_up", "ui_down")
	
	if lateral > 0:
		velocity.x = SPEED
	elif lateral < 0:
		velocity.x = -SPEED
	else: velocity.x = 0
	
	if vertical > 0:
		velocity.y = SPEED
	elif vertical < 0: 
		velocity.y = -SPEED
	else: 
		velocity.y = 0

	

	move_and_slide()
