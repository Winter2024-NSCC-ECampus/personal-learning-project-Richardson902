class_name Level extends Node2D

func _ready() -> void:
	self.y_sort_enabled = true # In case I forget to enable it lol
	PlayerManager.set_as_parent(self) # Hack to fix the y sorting issue
	LevelManager.level_load_started.connect(_free_level)

func _free_level() -> void:
	PlayerManager.unparent_player(self)
	queue_free()
