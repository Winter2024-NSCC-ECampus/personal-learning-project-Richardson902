extends Node2D

# Label displayed when player can interact
@onready var interact_label: Label = $InteractLabel

# List to keep track of currently interactable objects within range
var current_interactions := []

# Flag to control interaction availability
var can_interact := true

# Handle player inputs for interactions
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and can_interact:
		if current_interactions:
			if current_interactions[0].is_interactable:
				can_interact = false # Temp disable further interactions
				interact_label.hide() # Hide the label after interacting
			
			# Call the interact function of the closest interactable object
				await current_interactions[0].interact.call()
			
			# Re-enable intereaction after completion
				can_interact = true

# Update interaction prompt display during game loop
func _process(_delta: float) -> void:
	# Hide interaction label if no interactables are in range or interaction is disabled
	if not current_interactions or not can_interact:
		interact_label.hide()
	else:
		# Sort interactables by distance to player and show appropiate prompt
		current_interactions.sort_custom(_sort_by_nearest)
		if current_interactions[0].is_interactable:
			interact_label.text = current_interactions[0].interact_name
			interact_label.show()
		#else:
			## Hide label if nearest interactable is no longer valid
			#interact_label.hide

# Custom sort by nearest to player
func _sort_by_nearest(area1, area2):
	var area1_dist = global_position.distance_to(area1.global_position)
	var area2_dist = global_position.distance_to(area2.global_position)
	return area1_dist < area2_dist

func _on_interact_range_area_entered(area: Area2D) -> void:
	current_interactions.push_back(area)

func _on_interact_range_area_exited(area: Area2D) -> void:
	current_interactions.erase(area)
