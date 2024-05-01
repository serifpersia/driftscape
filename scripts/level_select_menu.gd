extends Control

const LEVEL_BTN = preload("res://scenes/canvas_ui/lvl_btn.tscn")

@export_dir var dir_path 
@onready var grid = $MarginContainer/HBoxContainer/VBoxContainer/GridContainer
@onready var timer = $Timer
@onready var btn_click = $btn_click

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_levels(dir_path)
	AudioPlayer.play_bgm_menu()

func get_levels(path):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != '':
			create_level_btn('%s/%s' %[dir.get_current_dir(), file_name], file_name)
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		print('An error has occured when trying access the levels path')

func create_level_btn(lvl_path: String, lvl_name: String):
	var btn = LEVEL_BTN.instantiate()
	var modified_btn_text = lvl_name.trim_suffix('.tscn')
	btn.text = modified_btn_text
	btn.level_path = lvl_path
	grid.add_child(btn)
	
	var score_label = btn.get_node("Score")
	if score_label != null:
		var score = Global.save_scores.get_level_score(modified_btn_text)
		var time =  Global.save_scores.get_level_time(modified_btn_text)
		score_label.text = 'Score: ' + score + '\n' + 'Time: ' + time
	else:
		print("Score label not found in button scene.")

func play_click():
	timer.start()
	btn_click.play()

func _on_main_menu_pressed():
	play_click()

func _on_timer_timeout():
	get_tree().change_scene_to_file("res://scenes/menu_scenes/menu.tscn")
