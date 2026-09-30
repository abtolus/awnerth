extends Control

export (PackedScene) var ItemTexture

onready var gc = $HBC/VBC/SC/GC

# Display the number of columns and rows of the item slots in the inventory UI.
func _ready():
	gc.columns = 5
	for i in GlobalData.items.keys():
		var item_texture = ItemTexture.instance()
		item_texture.rect_min_size = Vector2(128, 128)
		if GlobalData.items[i].has("recipe"):
			var item_id = i
			var _item_name = GlobalData.items[item_id]["name"]
			var item_icon = load("res://assets/images/items/%s" % GlobalData.items[item_id]["icon"])
			item_texture.get_node("Icon").set_texture(item_icon)
			item_texture.id = i
			
#			var item_quantity = InventoryData.dynamic_data[i]["item_stack"]
#			if item_quantity and item_quantity > 1:
#				item_texture.get_node("ItemQuantity").set_text(str(item_quantity))
				
#			if not GlobalData.items[item_id].has("usable"):
#				var item_value = InventoryData.dynamic_data[i]["item_value"]
#				var item_maximum_value = GlobalData.items[item_id]["maximum_value"]
#
#				item_texture.get_node("ItemValue").max_value = item_maximum_value
#				item_texture.get_node("ItemValue").value = item_value
#				item_texture.get_node("ItemValue").visible = !item_texture.get_node("ItemValue").visible
			gc.add_child(item_texture, true)

