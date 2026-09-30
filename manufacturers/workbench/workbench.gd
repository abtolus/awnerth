extends Manufacturer

onready var workbench_menu_tscn: PackedScene = preload("res://manufacturers/workbench/workbench_menu.tscn")

func _ready():
	target_menu_tscn = workbench_menu_tscn
