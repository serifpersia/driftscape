extends Button

@export_file var level_path
@onready var timer = $Timer
@onready var btn_click = $btn_click

func _on_pressed():
	play_click()

func play_click():
	timer.start()
	btn_click.play()

func _on_timer_timeout():
	if level_path == null:
		return
	get_tree().change_scene_to_file(level_path)
