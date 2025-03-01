class_name State_Stun extends State

@export var knockback_speed : float = 200.0
@export var decelerate_speed : float = 10.0
@export var invulnerable_duration : float = 1.0

var hurtbox : HurtBox
var direction : Vector2

var next_state : State = null

@onready var idle: State = $"../Idle"

func init() -> void:
	player.player_damaged.connect(_player_damaged)

# When player enters this state
func enter() -> void:
	player.animation_player.animation_finished.connect(_animation_finished)
	
	direction = player.global_position.direction_to(hurtbox.global_position)
	player.velocity = direction * -knockback_speed
	player.setDirection()
	player.updateAnimation("stun")
	
	player.make_invulnerable(invulnerable_duration)

# When player exits this state
func exit() -> void:
	next_state = null
	player.animation_player.animation_finished.disconnect(_animation_finished)

# When _process update in this state
func process(_delta : float) -> State:
	player.velocity -= player.velocity * decelerate_speed * _delta
	return next_state

# When _physics_process update in this state
func physics(_delta: float) -> State:
	return null

# When input events update in this state
func handleInput(_event: InputEvent) -> State:
	return null

func _player_damaged(_hurtbox : HurtBox) -> void:
	hurtbox = _hurtbox
	state_machine.changeState(self)

func _animation_finished(_a : String) -> void:
	next_state = idle
