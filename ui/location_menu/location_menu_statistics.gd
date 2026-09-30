extends Control

export (PackedScene) var ItemTexture

onready var grid_container = $MC/VBC/Control/MC/VBC/GridContainer
onready var description = $MC/VBC/Control2/MarginContainer/Description

onready var location_name = $MC/VBC/Name
onready var location_description = $MC/VBC/Control2/MarginContainer/Description

onready var label = $MC/VBC/Control/MC/VBC/Label

var location_id: String

func inform():
	grid_container.columns = 3
	if GlobalData.location_data[location_id]["description"]:
		location_description.set_text(GlobalData.location_data[location_id]["description"])
	if location_id == "home":
		location_name.set_text("Home")
		label.set_text("")
		grid_container.visible = false
		return
	location_name.set_text(GlobalData.location_data[location_id]["name"])
	
	label.set_text("Possible Items")
	grid_container.visible = true
	for key in GlobalData.rarity_data.keys():
		for j in GlobalData.location_data[location_id]["resource_data"][key]:
			var resource_texture = ItemTexture.instance()
			resource_texture.rect_min_size = Vector2(98, 98)
			var item_icon = load("res://assets/images/items/%s" % GlobalData.items[j]["icon"])
			
			resource_texture.get_node("Icon").set_texture(item_icon)
			resource_texture.get_node("Frame").self_modulate = Color(GlobalData.rarity_data[key]["color"])
			resource_texture.get_node("Frame").visible = true
			grid_container.call_deferred("add_child", resource_texture)


func _on_Travel_gui_input(event):
	if event is InputEventScreenTouch and not event.pressed:
		GlobalTscn.change_scene("res://locations/%s/%s.tscn" % [location_id, location_id], location_id)
