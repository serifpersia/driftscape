extends Control

func _ready():
	resume()

func resume():
	get_tree().paused = false
	hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
func _on_retry_pressed():
	resume()
	get_tree().reload_current_scene()

func _on_main_menu_pressed():
	resume()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene_to_file("res://scenes/menu.tscn")


func _on_level_select_pressed():
	get_tree().change_scene_to_file("res://scenes/level_selector_menu.tscn")
