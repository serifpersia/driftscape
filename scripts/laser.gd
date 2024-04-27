extends RayCast2D

const MAX_LENGTH = 2000

@onready var laser_raycast = $"."
@onready var line_2d = $Line2D

@onready var laser_sound = $"../laser_sound"

var player: Player = null
	
func _physics_process(_delta):
	laser_raycast.target_position = Vector2(0, MAX_LENGTH)
	
	var collision_point = laser_raycast.get_collision_point()
	var local_collision_point = line_2d.to_local(collision_point)
	
	if laser_raycast.is_colliding():
		var collider = laser_raycast.get_collider()
		
		if collider is Player:
			line_2d.points[1] = local_collision_point
			player = collider
			player.decrease_health(2)
		else:
			var normal = laser_raycast.get_collision_normal()
			var line_width = line_2d.get("width")
			local_collision_point -= normal * (line_width / 2.0)
			line_2d.points[1] = local_collision_point
	
	if !laser_sound.playing:
		laser_sound.play()
