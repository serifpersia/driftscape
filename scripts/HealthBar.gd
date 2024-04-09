extends ProgressBar

@onready var damage_bar = $DamageBar

var health = 0 : set = _set_health

func init_health(_health):
	health = _health
	max_value = health
	value = health
	damage_bar.max_value = health
	damage_bar.value = health

func _set_health(new_health):
	health = min(max_value, new_health)
	value = health
	
	var tween = create_tween()
	tween.tween_property(damage_bar, "value", health, 0.25)
