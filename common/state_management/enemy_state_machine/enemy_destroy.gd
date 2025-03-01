class_name EnemyStateDestroy extends EnemyState

@export var anim_name : String = "destroy"
@export var knockback_speed : float = 200.0
@export var decelerate_speed : float = 10.0

var dropped_item = preload("res://entities/items/coin/coin.tscn")

var _damage_position : Vector2
var _direction : Vector2

# On initialization
func init() -> void:
	enemy.enemy_destroyed.connect(_on_enemy_destroyed)
	pass

# On enter
func enter() -> void:
	enemy.invulnerable = true
	
	_direction = enemy.global_position.direction_to(_damage_position)
	enemy.setDirection(_direction)
	enemy.velocity = _direction * -knockback_speed
	
	enemy.update_animation(anim_name)
	enemy.animation_player.animation_finished.connect(_on_animation_finished)
	
	PlayerManager.reward_xp(enemy.xp_reward)
	disable_hurt_box()
	drop_item()
	pass

# On exit
func exit() -> void:
	pass

# During process of this state
func process(_delta: float) -> EnemyState:
	enemy.velocity -= enemy.velocity * decelerate_speed * _delta
	return null

func physics(_delta : float) -> EnemyState:
	return null;

# On damage, set state to stun state
func _on_enemy_destroyed(hurtbox : HurtBox) -> void:
	_damage_position = hurtbox.global_position
	state_machine.change_state(self)

func _on_animation_finished(_a : String) -> void:
	if enemy.can_respawn == true:
		enemy.respawn_timer.start()
		await enemy.respawn_timer.timeout
	enemy.queue_free()

func disable_hurt_box() -> void:
	var hurt_box : HurtBox = enemy.get_node_or_null("HurtBox")
	if hurt_box:
		hurt_box.moinitoring = false

func drop_item() -> void:
	var item_instance = dropped_item.instantiate()
	item_instance.global_position = enemy.global_position
	get_parent().call_deferred("add_child", item_instance)
	pass
