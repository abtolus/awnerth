extends Manufacturer

onready var burning_furnance_menu_tscn: PackedScene = preload("res://manufacturers/burning_furnance/burning_furnance_menu.tscn")

func _ready():
	target_menu_tscn = burning_furnance_menu_tscn
