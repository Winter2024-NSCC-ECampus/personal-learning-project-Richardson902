extends CanvasLayer

var collected_items: int = 0
@onready var label: Label = $Control/ItemsCollected

func _ready() -> void:
	pass

func increment_collection(amount: int):
	collected_items += amount	
	label.text = "Items Collected: %d" % collected_items
