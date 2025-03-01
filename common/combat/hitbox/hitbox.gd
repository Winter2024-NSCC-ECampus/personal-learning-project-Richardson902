class_name HitBox extends Area2D

signal Damaged(hurtbox : HurtBox)

func take_damage(hurtbox : HurtBox) -> void:
	Damaged.emit(hurtbox)
