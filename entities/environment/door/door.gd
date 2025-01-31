extends StaticBody2D

# Instances of the interactable and sprite
@onready var interactable: Area2D = $Interactable
@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D

# Regions for open and closed frames of the door (yucky tilemap thing, would rather use frame indexes)
var closed_region = Rect2(Vector2(109, 32), Vector2(18, 28))
var open_region = Rect2(Vector2(109, 0), Vector2(19, 29))

# To keep track of door state
var is_open: bool = false

# Assign interaction function to the callable function in Interactable
func _ready() -> void:
	interactable.interact = _on_interact

# If has key
# label name = "Unlock door"
# default = "Door is locked"

# The callable calls this function
func _on_interact():
	if is_open:
		close_door()
		collision.disabled = false
	else:
		open_door()
		collision.disabled = true
		
# Example of handling with key:
#func _on_interact():
	#if interactable.interact_name == "Unlock Door" and has_key:
		# interactable.interact_name = "Open Door" Unlock the door if the player has the key
	#elif is_open:
		#close_door()
		#collision.disabled = false
	#else:
		#open_door()
		#collision.disabled = true

# Sets the door states
func open_door():
	sprite.region_rect = open_region
	interactable.interact_name = "Close Door"
	is_open = true
	
func close_door():
	sprite.region_rect = closed_region
	interactable.interact_name = "Open Door"
	is_open = false

# If want to have it one time interact, call these methods
# interactable.is_interactable = false
# interactable.queue_free()
