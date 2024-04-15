extends Camera2D

var baseZoom: Vector2 = Vector2(1.35, 1.35)
var minZoom: Vector2 = Vector2(0.25, 0.25)
var zoomSpeed: float = 0.1
var sensitivity: float = 0.25

@onready var start_time = $"../StartTime"

func _ready():
	zoom = Vector2(0.75, 0.75)

func _process(_delta):
	if start_time.goDisplayed:
		var playerVelocity: Vector2 = get_parent().velocity
	
		var velocityMagnitude: float = playerVelocity.length()
		var scaledVelocity: float = pow(velocityMagnitude, sensitivity)
		var targetZoom: Vector2 = baseZoom - (baseZoom - minZoom) * scaledVelocity * zoomSpeed
		targetZoom.x = clamp(targetZoom.x, minZoom.x, baseZoom.x)
		targetZoom.y = clamp(targetZoom.y, minZoom.y, baseZoom.y)

		zoom = zoom.lerp(targetZoom, 0.0085)
