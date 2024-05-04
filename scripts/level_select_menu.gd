extends Control

const LEVEL_BTN = preload("res://scenes/canvas_ui/lvl_btn.tscn")

@export_dir var starter_levels_dir_path
@export_dir var custom_levels_dir_path 
@onready var timer = $Timer
@onready var btn_click = $btn_click
@onready var stage_1_grid = $HBoxContainer/StarterLevels/ScrollContainer/GridContainer/Stage1Levels
@onready var stage_2_grid = $HBoxContainer/StarterLevels/ScrollContainer/GridContainer/Stage2Levels
@onready var stage_3_grid = $HBoxContainer/StarterLevels/ScrollContainer/GridContainer/Stage3Levels
@onready var custom_stage_levels = $HBoxContainer/CustomLevels/ScrollContainer/GridContainer/Custom_Stage_Levels


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_levels(starter_levels_dir_path, custom_levels_dir_path)
	AudioPlayer.play_bgm_menu()

func get_levels(starter_path, custom_path):
	var dir = DirAccess.open(starter_path)
	var custom_dir = DirAccess.open(custom_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != '':
			if file_name.begins_with("custom"):
				create_custom_level_btn('%s/%s' % [dir.get_current_dir(), file_name], file_name)
			else:
				create_level_btn('%s/%s' % [dir.get_current_dir(), file_name], file_name)
			file_name = dir.get_next()
		dir.list_dir_end()
	else:
		print('An error has occurred when trying to access the levels path')

	if custom_dir:
		custom_dir.list_dir_begin()
		var custom_file_name = custom_dir.get_next()
		while custom_file_name != '':
			create_custom_level_btn('%s/%s' % [custom_dir.get_current_dir(), custom_file_name], custom_file_name)
			custom_file_name = custom_dir.get_next()
		custom_dir.list_dir_end()
	else:
		print('An error has occurred when trying to access the custom levels path')

func create_custom_level_btn(lvl_path: String, lvl_name: String):
	var btn = LEVEL_BTN.instantiate()
	var modified_btn_text = lvl_name.trim_suffix('.tscn')
	btn.text = modified_btn_text
	btn.level_path = lvl_path
	custom_stage_levels.add_child(btn)
	
	var score_label = btn.get_node("Score")
	if score_label != null:
		var score = Global.save_scores.get_level_score(modified_btn_text)
		var time = Global.save_scores.get_level_time(modified_btn_text)
		score_label.text = 'Score: ' + score + '\n' + 'Time: ' + time
	else:
		print("Score label not found in button scene.")


func create_level_btn(lvl_path: String, lvl_name: String):
	var btn = LEVEL_BTN.instantiate()
	var modified_btn_text = lvl_name.trim_suffix('.tscn')
	btn.text = modified_btn_text
	btn.level_path = lvl_path

	var level_num = int(modified_btn_text.replace("level", ""))
	if level_num >= 1 and level_num <= 5:
		stage_1_grid.add_child(btn)
	elif level_num >= 6 and level_num <= 10:
		stage_2_grid.add_child(btn)
	elif level_num >= 11 and level_num <= 15:
		stage_3_grid.add_child(btn)
	else:
		print("Level number out of range.")

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
