extends StaticBody2D
class_name Manufacturer

export (String) var manufacturer_id

onready var menu_container = get_node("../../UI/UI2/MenuContainer")
onready var inventory_menu_tscn: PackedScene = preload("res://ui/menu_container/inventory_menu/inventory_menu.tscn")
var target_menu_tscn: PackedScene

var minimap_tr: String = "object"

func _ready():
	pass

func get_interact():
	# Get the data of the interacted manufacturer from the menu data tres resource
	MenuData.target_manufacturer_data["manufacturer_id"] = manufacturer_id
	MenuData.menu_data["target_manufacturer_data"].merge(MenuData.menu_data_tres.static_menu_data[MenuData.menu_data["target_manufacturer_data"]["manufacturer_id"]], true)
	
	var inventory_menu = inventory_menu_tscn.instance()
	var target_menu = target_menu_tscn.instance()
	var control = menu_container.get_node("Control")
	menu_container.visible = true
	
	control.add_child(inventory_menu)
	control.add_child(target_menu)
