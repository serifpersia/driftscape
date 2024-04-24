extends AnimatableBody2D

var player: Player

func _on_area_2d_body_entered(body):
	if body.has_method("decrease_health"):
		player = body
		player.decrease_health(1)
