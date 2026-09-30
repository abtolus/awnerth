class_name ItemContainer
extends StaticBody2D

onready var menu_container = get_node("../../UI/UI2/MenuContainer")
onready var inventory_menu_tscn: PackedScene = preload("res://ui/menu_container/inventory_menu/inventory_menu.tscn")
var target_menu_tscn: PackedScene

var minimap_tr: String = "object"

func get_interact():
	MenuData.target_item_container_data["item_container_id"] = self.name
	if MenuData.menu_data_tres.static_menu_data["item_container_database"].has(self.name):
		MenuData.menu_data["target_item_container_data"].merge(MenuData.menu_data_tres.static_menu_data["item_container_database"][self.name], true)
	else:
		var new_item_container_data: Dictionary = {"item_slots": null}
		new_item_container_data.merge(MenuData.create_item_container_menu("ICS"), true)
		MenuData.menu_data["target_item_container_data"].merge(new_item_container_data, true)
		MenuData.menu_data_tres.static_menu_data["item_container_database"][self.name] = new_item_container_data
		
	var inventory_menu = inventory_menu_tscn.instance()
	var target_menu = target_menu_tscn.instance()
	target_menu.memory_id = self.name
	var control = menu_container.get_node("Control")
	menu_container.visible = true
	
	control.add_child(inventory_menu)
	control.add_child(target_menu)
