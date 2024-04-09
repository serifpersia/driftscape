extends Node2D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(_delta):
	var mouse_pos = get_global_mouse_position()
	position = mouse_pos
