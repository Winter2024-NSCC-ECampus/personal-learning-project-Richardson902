extends Node

# Player scene
const PLAYER = preload("res://entities/player/player.tscn")

signal player_leveled_up

var player: Player
var player_spawned : bool = false # Keep track of player spawned or not

const MAX_HEALTH: int = 100
var health : int

var level_requirements = [0, 20, 40, 60, 80, 90, 100]

func _ready() -> void:
	add_player_instance()
	await get_tree().create_timer(0.2).timeout
	player_spawned = true
	health = MAX_HEALTH
	PlayerHud.level.text = str(player.level)
	PlayerHud.xp_bar.max_value = level_requirements[player.level]

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

func reward_xp(_xp : int) -> void:
	player.xp += _xp
	print("XP gained ", _xp)
	if player.xp >= level_requirements[player.level]:
		print("Level up ", player.level + 1)
		player.level += 1
		player.max_health += 2
		player.health += 2
		player.attack += 2

		PlayerHud.update_health(player.health, player.max_health)
		player.xp = 0
		player_leveled_up.emit()
		#PlayerHud.level.text = str(player.level)
		#PlayerHud.xp_bar.max_value = level_requirements[player.level]
	PlayerHud.xp_bar.value = player.xp
