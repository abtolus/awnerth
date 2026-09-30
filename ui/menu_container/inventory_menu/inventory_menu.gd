extends Control

export (PackedScene) var InventorySlot

onready var use_button: Node = $VBoxContainer/Title/HBoxContainer/UseButton
onready var split_button: Node = $VBoxContainer/Title/HBoxContainer/SplitButton
onready var delete_button: Node = $VBoxContainer/Title/HBoxContainer/DeleteButton
onready var statistics: Node = $VBoxContainer/Statistics
onready var inventory_slots: Node = $VBoxContainer/InventorySlots

# Display the number of columns and rows of the item slots in the inventory UI.
func _ready():
	MenuData.use_button_node = use_button
	MenuData.split_button_node = split_button
	MenuData.delete_button_node = delete_button
	MenuData.statistics_node = statistics
	
	inventory_slots.columns = 5
	for i in MenuData.inventory_data.keys():
		var new_inventory_slot = InventorySlot.instance()
		if MenuData.inventory_data[i]["item_id"]:
			var item_id = MenuData.inventory_data[i]["item_id"]
			var _item_name = GlobalData.items[item_id]["name"]
			var item_icon = load("res://assets/images/items/%s" % GlobalData.items[item_id]["icon"])
			new_inventory_slot.get_node("ItemIcon").set_texture(item_icon)
			
			var item_quantity = MenuData.inventory_data[i]["item_stack"]
			if item_quantity and item_quantity > 1:
				new_inventory_slot.get_node("ItemQuantity").set_text(str(item_quantity))
				
			if not GlobalData.items[item_id].has("usable"):
				var item_value = MenuData.inventory_data[i]["item_value"]
				var item_maximum_value = GlobalData.items[item_id]["maximum_value"]
				
				new_inventory_slot.get_node("ItemValue").max_value = item_maximum_value
				new_inventory_slot.get_node("ItemValue").value = item_value
				new_inventory_slot.get_node("ItemValue").visible = !new_inventory_slot.get_node("ItemValue").visible
		inventory_slots.add_child(new_inventory_slot, true)

