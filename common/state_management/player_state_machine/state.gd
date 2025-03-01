class_name State extends Node

# Stores player as variable
static var player: Player
static var state_machine : PlayerStateMachine

func _ready() -> void:
	pass # Replace with function body.

func init() -> void:
	pass

# When player enters this state
func enter() -> void:
	pass

# When player exits this state
func exit() -> void:
	pass

# When _process update in this state
func process(_delta : float) -> State:
	return null

# When _physics_process update in this state
func physics(_delta: float) -> State:
	return null

# When input events update in this state
func handleInput(_event: InputEvent) -> State:
	return null
