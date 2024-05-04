extends Node2D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	var pos = get_viewport_rect().size / 2.0
	Input.warp_mouse(pos)

func _process(_delta):
	var mouse_pos = get_global_mouse_position()
	position = mouse_pos
