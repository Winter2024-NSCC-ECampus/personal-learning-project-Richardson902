class_name PlayerCamera extends Camera2D

var max_zoom = 4
var min_zoom = 1
var target_zoom = Vector2(2, 2) # When instatiate new player, might reset to 2, 2. Might need to track this globally.
var zoom_factor = 1.1
var zoom_speed = 0.5

func _ready():
	# Update the camera bounds to reflect the new level bounds
	LevelManager.level_bounds_changed.connect(update_limits)
	update_limits(LevelManager.current_level_bounds)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("zoom_in"):
		target_zoom *= zoom_factor
	if event.is_action_pressed("zoom_out"):
		target_zoom /= zoom_factor
	
	# Clamp the values so there's no infinite zoom
	target_zoom.x = clamp(target_zoom.x, min_zoom, max_zoom)
	target_zoom.y = clamp(target_zoom.y, min_zoom, max_zoom)
	
func _process(_delta: float) -> void:
	# Lerp to smooth the camera zooming
	zoom = lerp(zoom, target_zoom, zoom_speed)
	
# Get set the bounds of the level
func update_limits(bounds: Array[Vector2]) -> void:
	if bounds == []:
		return
	limit_left = int(bounds[0].x)
	limit_top = int(bounds[0].y)
	limit_right = int(bounds[1].x)
	limit_bottom = int(bounds[1].y)
	print("left: ", limit_left, " right: ", limit_right, " top: ", limit_top, " bottom: ", limit_bottom)
