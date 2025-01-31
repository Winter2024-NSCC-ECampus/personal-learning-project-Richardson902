class_name LevelBounds extends TileMapLayer

func _ready():
	LevelManager.change_level_bounds(get_level_bounds())


func get_level_bounds() -> Array[Vector2]:
	var bounds : Array[Vector2] = []
	bounds.append(Vector2(get_used_rect().position * rendering_quadrant_size))
	bounds.append(Vector2(get_used_rect().end * rendering_quadrant_size))
	return bounds
