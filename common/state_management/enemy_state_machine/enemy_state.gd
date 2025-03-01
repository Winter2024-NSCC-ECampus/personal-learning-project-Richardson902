class_name EnemyState extends Node

# Store reference to enemy that this state belongs to
var enemy : Enemy
var state_machine : EnemyStateMachine

# On initialization
func init() -> void:
	pass

# On enter
func enter() -> void:
	pass

# On exit
func exit() -> void:
	pass

# During process of this state
func process(_delta: float) -> EnemyState:
	return null
