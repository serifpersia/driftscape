extends Control

func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/menu_scenes/level_selector_menu.tscn")

func _on_quit_pressed():
	get_tree().quit()

func _on_play_mouse_entered():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_play_mouse_exited():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _on_quit_mouse_entered():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_quit_mouse_exited():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
