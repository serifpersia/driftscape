extends AnimatableBody2D

var rotation_speed = 2.00
@export var antiClockWise : bool 

func _process(delta):
	if antiClockWise:
		$Sprite2D.global_rotation -= rotation_speed * delta
		$CollisionPolygon2D.global_rotation -= rotation_speed * delta
	else:
		$Sprite2D.global_rotation += rotation_speed * delta
		$CollisionPolygon2D.global_rotation += rotation_speed * delta
