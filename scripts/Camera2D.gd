extends Camera2D

var baseZoom: Vector2 = Vector2(1.1575, 1.1575)
var minZoom: Vector2 = Vector2(0.125, 0.125)
var zoomSpeed: float = 0.1
var sensitivity: float = 0.2375

var maxOffset = 750.0
var targetOffset = 0.0
var lerpSpeed = 0.15

@onready var start_time = $"../StartTime"

func _ready():
	zoom = Vector2(0.75, 0.75)

func _process(delta):
	if start_time.goDisplayed:
		var playerVelocity: Vector2 = get_parent().velocity
	
		var velocityMagnitude: float = playerVelocity.length()
		var scaledVelocity: float = pow(velocityMagnitude, sensitivity)
		var targetZoom: Vector2 = baseZoom - (baseZoom - minZoom) * scaledVelocity * zoomSpeed
		targetZoom.x = clamp(targetZoom.x, minZoom.x, baseZoom.x)
		targetZoom.y = clamp(targetZoom.y, minZoom.y, baseZoom.y)
		
		if playerVelocity.x > 0:
			targetOffset = maxOffset
		elif playerVelocity.x < 0:
			targetOffset = -maxOffset
		else:
			targetOffset = 0.0

		offset.x = lerp(offset.x, targetOffset, lerpSpeed * delta)
		zoom = zoom.lerp(targetZoom, 0.0085)
