class_name State_Attack extends State

var attacking : bool = false

@export var attack_sound : AudioStream
@export_range(1, 20, 0.5) var decelerate_speed : float = 5.0

@onready var idle: State = $"../Idle"
@onready var walk: State = $"../Walk"
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var attack_animation: AnimationPlayer = $"../../PlayerSprites/Skeleton/Swing/AnimationPlayer"
@onready var audio: AudioStreamPlayer2D = $"../../Audio/AudioStreamPlayer2D"
@onready var hurtbox: HurtBox = %AttackHurtBox




# When player enters this state
func enter() -> void:
	player.updateAnimation("attack")
	attack_animation.play("attack_" + player.animDirection())
	animation_player.animation_finished.connect(end_attack)
	
	audio.stream = attack_sound
	audio.pitch_scale = randf_range(0.9, 1.1)
	audio.play()
	
	attacking = true
	
	await get_tree().create_timer(0.075).timeout
	if attacking:
		hurtbox.monitoring = true
	
	pass

# When player exits this state
func exit() -> void:
	animation_player.animation_finished.disconnect(end_attack)
	attacking = false
	hurtbox.monitoring = false
	pass

# When _process update in this state
func process(_delta : float) -> State:
	player.velocity -= player.velocity * decelerate_speed * _delta
	if attacking == false:
		if player.direction == Vector2.ZERO:
			return idle
		else:
			return walk
	return null

# When _physics_process update in this state
func physics(_delta: float) -> State:
	return null

# When input events update in this state
func handleInput(_event: InputEvent) -> State:
	return null
	
func end_attack( _newAnimName : String) -> void:
	attacking = false
