class_name Enemy extends CharacterBody2D

signal direction_changed(new_direction : Vector2)
signal enemy_damaged(hurtbox : HurtBox)
signal enemy_destroyed(hurtbox : HurtBox)

const DIR_4 = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]

@export var health_component : HealthComponent
@export var xp_reward : int = 1
@export var respawn_time: int = 1
@export_file var enemy_scene
@export var can_respawn : bool

var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
var player : Player
var invulnerable : bool = false
var spawn_position : Vector2

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var hitbox: HitBox = $HitBox
@onready var state_machine : EnemyStateMachine = $EnemyStateMachine
@onready var respawn_timer: Timer = $RespawnTimer
@onready var spawn_marker: Marker2D = $SpawnPosition

func _ready() -> void:
	spawn_position = spawn_marker.global_position
	respawn_timer.wait_time = respawn_time
	state_machine.initialize(self)
	player = PlayerManager.player
	hitbox.Damaged.connect(_take_damage)
	pass

func _physics_process(_delta: float) -> void:
	move_and_slide()

func setDirection(_new_direction : Vector2) -> bool:
	direction = _new_direction
	if direction == Vector2.ZERO:
		return false # Return if player is standing still
		
	var direction_id : int = int(round(
		(direction + cardinal_direction * 0.1).angle()
		/ TAU * DIR_4.size()
	))
	
	var new_dir = DIR_4[direction_id]
	
	if new_dir == cardinal_direction:
		return false
	
	cardinal_direction = new_dir
	direction_changed.emit(new_dir)
	sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1 # Flips sprite via scaling
	
	return true

func update_animation(state : String) -> void:
	animation_player.play(state + "_" + animDirection())
	
func animDirection() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"

func _take_damage(hurtbox : HurtBox) -> void:
	if invulnerable == true:
		return

	if health_component:
		health_component.damage(hurtbox.damage)
		if health_component.health > 0:
			enemy_damaged.emit(hurtbox)
		else:
			enemy_destroyed.emit(hurtbox)
	
func _on_respawn_timer_timeout() -> void:
	print("Enemy Spawning")
	var new_enemy = load(enemy_scene).instantiate()
	
	new_enemy.global_position = spawn_position
	
	get_parent().add_child(new_enemy)
