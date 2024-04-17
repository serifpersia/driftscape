extends Control

@onready var timer = $Timer
@onready var btn_click = $btn_click

var last_pressed_button = null

func _ready():
	resume()

func resume():
	get_tree().paused = false
	hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _on_retry_pressed():
	play_click()
	last_pressed_button = "retry"

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
	if last_pressed_button == "retry":
		resume()
		get_tree().reload_current_scene()
	elif last_pressed_button == "levelselect":
		get_tree().change_scene_to_file("res://scenes/menu_scenes/level_selector_menu.tscn")
	elif last_pressed_button == "mainmenu":
		resume()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().change_scene_to_file("res://scenes/menu_scenes/menu.tscn")
