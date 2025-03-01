class_name EnemyStateMachine extends Node

var states: Array[EnemyState]
var prev_state : EnemyState
var current_state : EnemyState

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	pass

func _process(delta: float) -> void:
	change_state(current_state.process(delta))

func _physics_process(delta: float) -> void:
	change_state(current_state.physics(delta))

func initialize(_enemy : Enemy) -> void:
	states = []
	
	# Build array of states
	for c in get_children():
		if c is EnemyState:
			states.append(c)
	
	# Setup each state
	for s in states:
		s.enemy = _enemy
		s.state_machine = self
		s.init()
	
	# Initialize state to first state
	if states.size() > 0:
		change_state(states[0])
		process_mode = Node.PROCESS_MODE_INHERIT

func change_state(new_state : EnemyState) -> void:
	if new_state == null || new_state == current_state:
		return
	
	# If currently in a state, exit it
	if current_state:
		current_state.exit()
	
	# Shuffle around states and enter new state
	prev_state = current_state
	current_state = new_state
	current_state.enter()
