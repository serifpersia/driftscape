extends Node2D

var player: Player

func _on_area_2d_body_entered(body):
	if body.has_method("level_finish"):
		player = body
		player.level_finish()
