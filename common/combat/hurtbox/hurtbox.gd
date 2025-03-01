class_name HurtBox extends Area2D

# Edit damage for atttacking enemy here based on weapon
@export var damage : int = 1

func _on_area_entered(area: Area2D) -> void:
	if area is HitBox:
		area.take_damage(self)
	pass
