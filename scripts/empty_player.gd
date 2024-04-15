extends CharacterBody2D

var Speed_multiplier: float = 6

func _physics_process(_delta):
	Speed_multiplier = lerp(2, 6, 1)
	var targetDir: Vector2 = (get_global_mouse_position() - global_position)
	var targetVelocity: Vector2 = targetDir * Speed_multiplier
	velocity = velocity.lerp(targetVelocity, 0.5)
	move_and_slide()
