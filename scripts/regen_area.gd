extends Node2D

var player: Player  # Reference to the Player instance

var isInRegenArea: bool
var regenAmount = 10
var timeSinceRegen: float = 0
var regenInterval: float = 0.15

func _on_area_2d_body_entered(body):
	if body.has_method("increase_health"):  # Check if the body is a Player instance
		player = body  # Assign the Player instance to the player variable
		isInRegenArea = true

func _on_area_2d_body_exited(body):
	if body == player:
		player = null  # Reset the player variable when the Player exits the area
		isInRegenArea = false

func _process(delta):
	if isInRegenArea:
		timeSinceRegen += delta
		if timeSinceRegen >= regenInterval:
			player.increase_health(regenAmount)
			timeSinceRegen = 0  # Reset the timer after regeneration
