class_name State_Idle extends State

@onready var walk: State = $"../Walk"
@onready var attack: State = $"../Attack"

# When player enters this state
func enter() -> void:
	player.updateAnimation("idle")
	pass

# When player exits this state
func exit() -> void:
	pass

# When _process update in this state
func process(_delta : float) -> State:
	if player.direction != Vector2.ZERO:
		return walk
	player.velocity = Vector2.ZERO
	return null

# When _physics_process update in this state
func physics(_delta: float) -> State:
	return null

# When input events update in this state
func handleInput(_event: InputEvent) -> State:
	if _event.is_action_pressed("attack"):
		return attack
	return null
