extends StaticBody2D

# Instances of the interactable and sprite
@onready var interactable: Area2D = $Interactable
@onready var sprite: Sprite2D = $Sprite2D
@onready var growth_timer: Timer = $GrowthTimer
@onready var marker: Marker2D = $Marker2D

var apple = preload("res://entities/items/apple/apple.tscn")

# Regions for open and closed frames of the door (yucky tilemap thing, would rather use frame indexes)
var apples = Rect2(Vector2(60, 160), Vector2(36, 48))
var no_apples = Rect2(Vector2(108, 160), Vector2(36, 48))
var has_apples: bool = true

# Assign interaction function to the callable function in Interactable
func _ready() -> void:
	interactable.interact = _on_interact

# The callable calls this function
func _on_interact():
	if has_apples:
		pick_apples()

func update_state() -> void:
	sprite.region_rect = apples if has_apples else no_apples
	
	# if tree has apples, tree is interactable
	interactable.is_interactable = has_apples

func pick_apples() -> void:
	has_apples = false
	update_state()
	drop_apple()

func _on_growth_timer_timeout() -> void:
	has_apples = true
	update_state()
	
func drop_apple() -> void:
	var apple_instance = apple.instantiate()
	apple_instance.global_position = marker.global_position
	get_parent().add_child(apple_instance)
	print(apple_instance.global_position)
	growth_timer.start()
