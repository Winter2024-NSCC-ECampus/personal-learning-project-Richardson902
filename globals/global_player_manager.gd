extends Node

# Player scene
const PLAYER = preload("res://entities/player/player.tscn")

var player: Player
var player_spawned : bool = false # Keep track of player spawned or not

func _ready() -> void:
	add_player_instance()
	await get_tree().create_timer(0.2).timeout
	player_spawned = true

# Instantiate the player instead of exisitng by default
func add_player_instance() -> void:
	player = PLAYER.instantiate()
	add_child(player)

# Method to set the player position
func set_player_position(_new_pos: Vector2) -> void:
	player.global_position = _new_pos
	
# Hacks to fix y sorting
func set_as_parent( _parent : Node2D) -> void:
	if player.get_parent():
		player.get_parent().remove_child(player)
	_parent.add_child(player)
	
func unparent_player(_parent : Node2D) -> void:
	_parent.remove_child(player)
