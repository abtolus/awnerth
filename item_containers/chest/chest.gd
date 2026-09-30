extends ItemContainer

onready var chest_menu_tscn: PackedScene = preload("res://item_containers/chest/chest_menu.tscn")

var chest_data: Dictionary = {"slots": 25}

func _ready():
	target_menu_tscn = chest_menu_tscn
