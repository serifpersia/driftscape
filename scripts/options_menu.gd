extends Control

@onready var timer = $Timer
@onready var btn_click = $btn_click

@onready var master_vol = $MarginContainer/HBoxContainer/VBoxContainer/BoxContainer/master_vol
@onready var sfx_vol = $MarginContainer/HBoxContainer/VBoxContainer/BoxContainer/sfx_vol
@onready var bgm_vol = $MarginContainer/HBoxContainer/VBoxContainer/BoxContainer/bgm_vol

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func play_click():
	save_vol(master_vol)
	save_vol(sfx_vol)
	save_vol(bgm_vol)
	timer.start()
	btn_click.play()

func save_vol(vol):
	Global.save_options.save_volume_for_bus(vol.bus_name, vol.value)
	Global.save_options.save_defaults("Default", 0)


func _on_main_menu_pressed():
	play_click()

func _on_timer_timeout():
	get_tree().change_scene_to_file("res://scenes/menu_scenes/menu.tscn")
