extends ItemIcon

func on_PlayerSheet_drop_data(origin_item_slot: Node, target_item_slot: Node, data: Dictionary, is_to_player_sheet: bool) -> void:
	if is_to_player_sheet:
		self_modulate = Color("ffffff")
		texture = data["origin_item_icon"]
		
		data["target_dictionary"][target_item_slot.name]["item_id"] = data["origin_item_id"]
		data["target_dictionary"][target_item_slot.name]["item_value"] = data["origin_item_value"]
		
		target_item_slot.get_node("ItemValue").value = data["origin_item_value"]
		target_item_slot.get_node("ItemValue").max_value = GlobalData.items[data["origin_item_id"]]["maximum_value"]
		target_item_slot.get_node("ItemValue").visible = true
		
		MenuData.set_statistics_data(data["origin_item_id"], data["target_item_id"], true)
		return
	
	if data["target_item_id"]:
			origin_item_slot.get_node("ItemIcon").texture = data["target_item_icon"]
			origin_item_slot.get_node("ItemValue").value = data["target_item_value"]
			origin_item_slot.get_node("ItemValue").max_value = GlobalData.items[data["target_item_id"]]["maximum_value"]
	else:
		origin_item_slot.get_node("ItemIcon").self_modulate = Color("000000")
		var default_texture = load("res://assets/images/silhouettes/%s.png" % data["origin_node"].get_parent().name)
		origin_item_slot.get_node("ItemIcon").set_texture(default_texture)
		origin_item_slot.get_node("ItemValue").visible = false
	
	MenuData.set_statistics_data(data["origin_item_id"], data["target_item_id"], false)
