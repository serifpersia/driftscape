extends Node2D

const MAX_LENGTH = 2000

@onready var laser_raycast = $Laser
@onready var line_2d = $Laser/Line2D

var player: Player = null

func _physics_process(_delta):
	laser_raycast.target_position = Vector2(0,MAX_LENGTH)
	if laser_raycast.is_colliding():
		var colliding_object = laser_raycast.get_collider()
		## Check if the colliding object is the player
		if colliding_object and colliding_object is Player:
			player = colliding_object
			if player.has_method("decrease_health"):
				player.decrease_health(1)
		# Update Line2D points to show collision point
		var collision_point = laser_raycast.get_collision_point()
		line_2d.points[1].y = collision_point.y + 64
