class_name EnemyStateStun extends EnemyState

@export var anim_name : String = "stun"
@export var knockback_speed : float = 200.0
@export var decelerate_speed : float = 10.0
@export_category("AI")
@export var next_state : EnemyState

var _damage_position : Vector2
var _direction : Vector2
var _animation_finished : bool = false



# On initialization
func init() -> void:
	enemy.enemy_damaged.connect(_on_enemy_damaged)
	pass

# On enter
func enter() -> void:
	_animation_finished = false
	
	_direction = enemy.global_position.direction_to(_damage_position)
	enemy.setDirection(_direction)
	enemy.velocity = _direction * -knockback_speed
	
	enemy.update_animation(anim_name)
	enemy.animation_player.animation_finished.connect(_on_animation_finished)
	pass

# On exit
func exit() -> void:
	enemy.animation_player.animation_finished.disconnect(_on_animation_finished)
	pass

# During process of this state
func process(_delta: float) -> EnemyState:
	if _animation_finished == true:
		return next_state
	enemy.velocity -= enemy.velocity * decelerate_speed * _delta
	return null

func physics(_delta : float) -> EnemyState:
	return null;

# On damage, set state to stun state
func _on_enemy_damaged(hurtbox : HurtBox) -> void:
	_damage_position = hurtbox.global_position
	state_machine.change_state(self)

func _on_animation_finished(_a : String) -> void:
	_animation_finished = true
