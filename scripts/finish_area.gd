extends Node2D

var player: Player  # Reference to the Player instance


func _on_area_2d_body_entered(body):
	if body.has_method("level_finish"):  # Check if the body is a Player instance
		player = body
		player.level_finish()
