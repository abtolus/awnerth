extends Manufacturer

onready var smelting_furnance_menu_tscn: PackedScene = preload("res://manufacturers/smelting_furnance/smelting_furnance_menu.tscn")

func _ready():
	target_menu_tscn = smelting_furnance_menu_tscn
