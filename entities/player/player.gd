class_name Player extends CharacterBody2D

signal direction_changed(new_direction : Vector2)
signal player_damaged(hurtbox : HurtBox)

var cardinal_direction = Vector2.DOWN
var direction = Vector2.ZERO

var invulnerable : bool = false
var health : int = 6
var max_health : int = 6

var level : int = 1
var xp : int = 0
var attack : int = 1 :
	set( v ):
		attack = v
		update_damage_values()

@onready var skeleton: Node2D = $PlayerSprites/Skeleton
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var state_machine: PlayerStateMachine = $StateMachine
@onready var hitbox: HitBox = $HitBox


func _ready() -> void:
	PlayerManager.player = self
	state_machine.initialize(self)
	hitbox.Damaged.connect(_take_damage)
	Engine.max_fps = 60
	update_health(99)
	update_damage_values()

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
	direction_changed.emit(new_direction)
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

func _take_damage(hurtbox : HurtBox):
	if invulnerable == true:
		return
	update_health(-hurtbox.damage)
	
	if health > 0:
		player_damaged.emit(hurtbox)
	else:
		player_damaged.emit(hurtbox)
		update_health(99)
	
	pass

func update_damage_values() -> void:
	%AttackHurtBox.damage += attack

func update_health( delta : int) -> void:
	health = clampi(health + delta, 0, max_health)
	PlayerHud.update_health(health, max_health)

func make_invulnerable(_duration : float = 1.0) -> void:
	invulnerable = true
	hitbox.monitoring = false
	
	await get_tree().create_timer(_duration).timeout
	
	invulnerable = false
	hitbox.monitoring = true
	pass
