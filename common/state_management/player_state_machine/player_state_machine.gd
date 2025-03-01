class_name PlayerStateMachine extends Node

# List of all possible states in the state machine
var states : Array[State]

# Reference to the previous state
var prev_state : State

# Reference to the current active state
var current_state: State

func _ready() -> void:
	# Disable processing initially to avoid unnecessary updates before initialization
	process_mode = Node.PROCESS_MODE_DISABLED

func _process(delta: float) -> void:
	# Handle per frame logic for the current state and transition to new state if needed
	changeState(current_state.process(delta))
	
func _physics_process(delta: float) -> void:
	# Handle physics related logic for the current state and transition if needed
	changeState(current_state.physics(delta))
	
func _unhandled_input(event: InputEvent) -> void:
	# Handle input events for current state and transition if needed
	changeState(current_state.handleInput(event))

func initialize(_player: Player) -> void:
	 # Initialize state machine by populating list of states from child nodes
	states = []
	
	for c in get_children():
		if c is State:
			states.append(c)
			
	if states.size() == 0:
		return
	
	states[0].player = _player # Assign the player to the first state
	states[0].state_machine = self
	
	for s in states:
		s.init()
	
	changeState(states[0]) # Set the initial state
	process_mode = Node.PROCESS_MODE_INHERIT # Enable processing to enherit mode from parent

func changeState(new_state: State) -> void:
	# Exit if the new state is null of the same as current state
	if new_state == null || new_state == current_state:
		return
		
	# Exit current state if one is active
	if current_state:
		current_state.exit()
		
	# Update references to the previous and current states
	prev_state = current_state
	current_state = new_state
	
	# Enter new state
	current_state.enter()
