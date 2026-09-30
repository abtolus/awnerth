class_name ItemContainerMenu
extends Control

export (String) var item_container_name
export (PackedScene) var ItemContainerSlot

onready var label = $VBC/Label
onready var item_container_slots = $VBC/SC/GC
var memory_id: String

func _ready():
	if has_method("generate"):
		call_deferred("generate")
	display()

func display():
	var item_slots = MenuData.menu_data["target_item_container_data"]["item_slots"]
	label.set_text(item_container_name)
	var memory_address: int = 100
	for i in item_slots.keys():
		var new_item_container_slot = ItemContainerSlot.instance()
		new_item_container_slot.name = "ICS%d" % memory_address
		memory_address += 1
		if item_slots[i]["item_id"]:
			var item_id = item_slots[i]["item_id"]
			var _item_name = GlobalData.items[item_id]["name"]
			var item_icon = load("res://assets/images/items/%s" % GlobalData.items[item_id]["icon"])
			new_item_container_slot.get_node("ItemIcon").set_texture(item_icon)
			
			var item_quantity = item_slots[i]["item_stack"]
			if item_quantity and item_quantity > 1:
				new_item_container_slot.get_node("ItemQuantity").set_text(str(item_quantity))
				
			if not GlobalData.items[item_id].has("usable"):
				var item_value = item_slots[i]["item_value"]
				var item_maximum_value = GlobalData.items[item_id]["maximum_value"]
				
				new_item_container_slot.get_node("ItemValue").max_value = item_maximum_value
				new_item_container_slot.get_node("ItemValue").value = item_value
				new_item_container_slot.get_node("ItemValue").visible = !new_item_container_slot.get_node("ItemValue").visible
		item_container_slots.add_child(new_item_container_slot, true)
