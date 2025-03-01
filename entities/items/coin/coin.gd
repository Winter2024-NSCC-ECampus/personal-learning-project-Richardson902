class_name Item extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		PlayerHud.increment_collection(1)
		animation_player.play("pickup")
