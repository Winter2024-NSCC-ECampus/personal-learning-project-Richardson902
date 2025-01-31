extends Node2D

func _ready() -> void:
	visible = false # Disable seeing the spawner
	if PlayerManager.player_spawned == false:
		
		 # Sets player position to the position of the spawner
		PlayerManager.set_player_position(global_position)
		
		PlayerManager.player_spawned = true
