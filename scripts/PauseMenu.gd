extends Control

@onready var player = $"../.."

var gameEnded

func _ready():
	hide()
	player.connect("gameEndedSignal", enableGameEnd)

func enableGameEnd():
	gameEnded = true

func resume():
	get_tree().paused = false
	hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func pause():
	get_tree().paused = true
	show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func togglePause():
	if Input.is_action_just_pressed("pause"):
		if gameEnded:
			return  # Don't toggle pause if the game has ended (finished or failed)
		
		if get_tree().paused:
			resume()
		else:
			pause()

func _on_resume_pressed():
	resume()

func _on_retry_pressed():
	resume()
	get_tree().reload_current_scene()

func _process(_delta):
	togglePause()


func _on_main_menu_pressed():
	resume()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
