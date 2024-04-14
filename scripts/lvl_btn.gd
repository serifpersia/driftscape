extends Button

@export_file var level_path

var initial_size = scale
var scaled_size = Vector2(1.25, 1.25)

func _on_mouse_entered():
	scale_button(scaled_size, .1)

func _on_mouse_exited():
	scale_button(initial_size, .1)

func _on_pressed():
	if level_path == null:
		return
	get_tree().change_scene_to_file(level_path)
	
func scale_button(end_size: Vector2, duration: float):
	var tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, 'scale', end_size, duration)
