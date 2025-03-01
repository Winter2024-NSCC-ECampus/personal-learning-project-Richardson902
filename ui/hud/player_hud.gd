extends CanvasLayer

var collected_items: int = 0
var hearts : Array[ HeartGUI ] = []

@onready var label: Label = $Control/ItemsCollected
@onready var xp_bar: ProgressBar = $Control/XpBar
@onready var level: Label = $Control/XpBar/Level

func _ready() -> void:
	for child in $Control/HFlowContainer.get_children():
		if child is HeartGUI:
			hearts.append(child)
			child.visible = false
	#PlayerManager.player_leveled_up.connect(update_health)
	PlayerManager.player_leveled_up.connect(update_experience)

func increment_collection(amount: int):
	collected_items += amount	
	label.text = "Items Collected: %d" % collected_items

func update_health(_health: int, _max_health: int) -> void:
	update_max_health(_max_health)
	for i in _max_health:
		update_heart(i, _health)
	pass

func update_heart(_index : int, _health : int) -> void:
	var _value : int = clampi(_health - _index * 2, 0, 2)
	hearts[_index].value = _value
	pass

func update_max_health(_max_health : int) -> void:
	var _heart_count : int = roundi(_max_health * 0.5)
	for i in hearts.size():
		if i < _heart_count:
			hearts[i].visible = true
		else:
			hearts[i].visible = false
	pass

func update_experience() -> void:
	level.text = str(PlayerManager.player.level)
	xp_bar.max_value = PlayerManager.level_requirements[PlayerManager.player.level]
	
