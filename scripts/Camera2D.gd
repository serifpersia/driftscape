extends Camera2D

var baseZoom: Vector2 = Vector2(1.5, 1.5)  # The base zoom level of the camera (X, Y)
var minZoom: Vector2 = Vector2(0.2, 0.2)  # The minimum zoom level (maximum zoomed out) (X, Y)
var zoomSpeed: float = 0.12 # The speed at which the camera zooms in/out based on velocity
var sensitivity: float = 0.25 # Adjust the sensitivity of the zoom to velocity changes

func _process(_delta):
	# Get the velocity from the parent node (assuming parent is the player character)
	var playerVelocity: Vector2 = get_parent().velocity
	
	# Calculate the current velocity magnitude
	var velocityMagnitude: float = playerVelocity.length()

	# Apply sensitivity to the velocity magnitude
	var scaledVelocity: float = pow(velocityMagnitude, sensitivity)
	# Calculate the zoom level based on scaled velocity
	var targetZoom: Vector2 = baseZoom - (baseZoom - minZoom) * scaledVelocity * zoomSpeed
	targetZoom.x = clamp(targetZoom.x, minZoom.x, baseZoom.x)
	targetZoom.y = clamp(targetZoom.y, minZoom.y, baseZoom.y)

	# Smoothly interpolate towards the target zoom level
	zoom = zoom.lerp(targetZoom, 0.0085)  # Adjust interpolation factor as needed
