extends Control

@onready var player = $"../.."
@onready var timer = $Timer
@onready var btn_click = $btn_click

var gameEnded
var last_pressed_button = null

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
			return
		
		if get_tree().paused:
			resume()
		else:
			pause()

func _on_resume_pressed():
	play_click()
	last_pressed_button = "resume"

func _on_retry_pressed():
	play_click()
	last_pressed_button = "retry"

func _process(_delta):
	togglePause()

func _on_level_select_pressed():
	play_click()
	last_pressed_button = "levelselect"

func _on_main_menu_pressed():
	play_click()
	last_pressed_button = "mainmenu"

func play_click():
	timer.start()
	btn_click.play()

func _on_timer_timeout():
	if last_pressed_button == "resume":
		resume()
	elif last_pressed_button == "retry":
		resume()
		get_tree().reload_current_scene()
	elif last_pressed_button == "levelselect":
		get_tree().change_scene_to_file("res://scenes/menu_scenes/level_selector_menu.tscn")
	elif last_pressed_button == "mainmenu":
		resume()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().change_scene_to_file("res://scenes/menu_scenes/menu.tscn")
