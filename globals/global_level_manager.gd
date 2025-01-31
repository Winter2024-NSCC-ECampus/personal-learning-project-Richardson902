extends Node

var current_level_bounds : Array[Vector2]
var target_transition : String
var position_offset : Vector2
signal level_bounds_changed(bounds: Array[Vector2])
signal level_load_started
signal level_loaded

func _ready() -> void:
	await get_tree().process_frame
	level_loaded.emit()

func change_level_bounds(bounds: Array[Vector2]) -> void:
	# Sets current bounds to new bounds
	current_level_bounds = bounds
	
	# Emit signal with new bounds
	level_bounds_changed.emit(bounds)
	

func load_new_level(
		level_path : String,
		_target_transition : String,
		_position_offset : Vector2
) -> void:
	get_tree().paused = true
	target_transition = _target_transition
	position_offset = _position_offset
	
	level_load_started.emit()
	
	await get_tree().process_frame # Level transition
	
	get_tree().change_scene_to_file(level_path)
	
	await get_tree().process_frame # Level transition
	
	get_tree().paused = false
	
	await get_tree().process_frame
	
	level_loaded.emit()
	
