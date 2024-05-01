extends StaticBody2D

var totalWeight: float = 0

func _on_area_2d_body_entered(body):
	if body is RigidBody2D:
		totalWeight += body.mass
		print("Weight on button:", totalWeight, "kg")
	if totalWeight >= 4:
		print("Open the door!")
