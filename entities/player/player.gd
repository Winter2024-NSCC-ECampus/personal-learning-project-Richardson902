class_name Player extends CharacterBody2D

var cardinal_direction = Vector2.DOWN
var direction = Vector2.ZERO

@onready var skeleton = $Skeleton
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var state_machine: PlayerStateMachine = $StateMachine

func _ready() -> void:
	state_machine.initialize(self)
	Engine.max_fps = 60

func _process(_delta: float) -> void:
	direction = Input.get_vector("left", "right", "up", "down") # Normalized vector
	
func _physics_process(_delta: float) -> void:
	move_and_slide()

func setDirection() -> bool:
	var new_direction : Vector2 = cardinal_direction
	if direction == Vector2.ZERO:
		return false # Return if player is standing still
		
	if direction.x != 0:
		new_direction = Vector2.LEFT if direction.x < 0 else Vector2.RIGHT
	elif direction.y != 0:
		new_direction = Vector2.UP if direction.y < 0 else Vector2.DOWN
	
	if new_direction == cardinal_direction:
		return false # Return if direction hasn't changed
		
	cardinal_direction = new_direction
	skeleton.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1 # Flips sprite via scaling
	
	return true

func animDirection() -> String:
	# Checks cardinal direction and returns string based on direction to pass to animation player
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"
	
func updateAnimation(state: String) -> void:
	animation_player.play(state + "_" + animDirection()) # Play anim based on the state and direction
	pass
