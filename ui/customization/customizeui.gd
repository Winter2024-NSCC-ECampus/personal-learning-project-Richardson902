extends Control

# Grap di link fi di nodes dem!
@onready var hair = $"../Skeleton/Hair"
@onready var shirt = $"../Skeleton/Shirt"
@onready var pants = $"../Skeleton/Pants"
@onready var shoes = $"../Skeleton/Shoes"
@onready var haircheck = $ColorRect/HairCheck
@onready var shirtcheck = $ColorRect/ShirtCheck
@onready var pantscheck = $ColorRect/PantsCheck
@onready var shoescheck = $ColorRect/ShoesCheck

var is_open = false

func _ready():
	update_sprite()
	close()
	
func _process(_delta):
	if Input.is_action_just_pressed("customize"):
		if is_open:
			close()
		else:
			open()
	elif Input.is_action_just_pressed("getnaked"):
		print("NAKED TIME!!!!!!!!!")
		haircheck.button_pressed = false
		shirtcheck.button_pressed = false
		pantscheck.button_pressed = false
		shoescheck.button_pressed = false

func open():
	visible = true
	is_open = true
	
func close():
	visible = false
	is_open = false

# Updates de sprite based pon di global style weh select
func update_sprite():
	hair.texture = Global.hair_collection[Global.selected_hair]
	shirt.texture = Global.shirt_collection[Global.selected_shirt]
	pants.texture = Global.pants_collection[Global.selected_pants]
	shoes.texture = Global.shoes_collection[Global.selected_shoes]

func _on_hair_check_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Global.selected_hair = "01"
		update_sprite()
	else:
		Global.selected_hair = "none"
		update_sprite()

func _on_shirt_check_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Global.selected_shirt = "01"
		update_sprite()
	else:
		Global.selected_shirt = "none"
		update_sprite()

func _on_pants_check_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Global.selected_pants = "01"
		update_sprite()
	else:
		Global.selected_pants = "none"
		update_sprite()

func _on_shoes_check_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Global.selected_shoes = "01"
		update_sprite()
	else:
		Global.selected_shoes = "none"
		update_sprite()
