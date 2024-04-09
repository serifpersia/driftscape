extends Node

func _ready():
	DiscordRPC.app_id = 1226128527049494588 # Application ID
	DiscordRPC.details = "Godot"
	DiscordRPC.state = "Level testing"

	DiscordRPC.large_image = "godot" # Image key from "Art Assets"
	DiscordRPC.large_image_text = "Godot"
	DiscordRPC.small_image = "godot_small" # Image key from "Art Assets"
	DiscordRPC.small_image_text = "Game design"

	DiscordRPC.start_timestamp = int(Time.get_unix_time_from_system()) # "02:46 elapsed"
  # DiscordRPC.end_timestamp = int(Time.get_unix_time_from_system()) + 3600 # +1 hour in unix time / "01:00:00 remaining"
	DiscordRPC.refresh() # Always refresh after changing the values!
