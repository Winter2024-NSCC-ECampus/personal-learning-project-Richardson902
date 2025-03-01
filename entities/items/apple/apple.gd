extends Area2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	fall_from_tree()

func fall_from_tree() -> void:
	animation_player.play("falling_apple")

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		PlayerHud.increment_collection(1)
		animation_player.play("pickup")
