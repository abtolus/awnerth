extends ItemIcon

func on_Manufacturer_origin_can_drop_data(origin_slot: String, data: Dictionary):
	var all_recipes: Dictionary = MenuData.target_manufacturer_data["all_recipes"]
	match origin_slot:
		"InputSlot":
			return iterate_through_recipes(data["origin_item_id"], "InputSlot", all_recipes)
		"CatalystSlot":
			return false if data["target_item_id"] and data["origin_node"].get_parent().name == "OutputSlot" else iterate_through_recipes(data["origin_item_id"], "CatalystSlot", all_recipes)
		"OutputSlot":
			return false
		_:
			return false

func on_Manufacturer_can_drop_data(target_slot: String, data: Dictionary) -> bool:
	var all_recipes: Dictionary = MenuData.target_manufacturer_data["all_recipes"]
	match target_slot:
		"InputSlot":
			return iterate_through_recipes(data["origin_item_id"], "InputSlot", all_recipes)
		"CatalystSlot":
			return false if data["target_item_id"] and data["origin_node"].get_parent().name == "OutputSlot" else iterate_through_recipes(data["origin_item_id"], "CatalystSlot", all_recipes)
		"OutputSlot":
			return false
		_:
			if data["target_item_id"] == data["origin_item_id"] or data["target_item_id"] == null:
				return true
			else:
				return false

func iterate_through_recipes(id: String, slot: String, data: Dictionary) -> bool:
	for i in data.keys():
		if id in data[i][slot].keys():
			return true
		elif data[i][slot].has("item_id") and id == data[i][slot]["item_id"]:
			return true
	return false
