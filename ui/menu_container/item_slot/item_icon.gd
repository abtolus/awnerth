extends TextureRect
class_name ItemIcon

export (String) var origin_panel

var memory_id: String

func get_drag_data(_position):
	var item_slot = get_parent()
	var data = {}
	data["origin_dictionary"] = MenuData.get_dictionary(origin_panel)
	
	var item_id = data["origin_dictionary"][item_slot.name]["item_id"]
	var item_stack = data["origin_dictionary"][item_slot.name]["item_stack"]
	var item_value = data["origin_dictionary"][item_slot.name]["item_value"]
	if item_id == null:
		return
		
	# Essential keys of the data dictionary
	data["origin_panel"] = origin_panel
	data["origin_node"] = self
	data["origin_item_icon"] = texture
	
	data["origin_item_id"] = item_id
	data["origin_item_stack"] = item_stack
	data["origin_item_value"] = item_value
	
	if GlobalData.items[item_id].has("usable"):
		data["origin__usable"] = GlobalData.items[item_id]["usable"]
	data["origin__equipment_slot"] = GlobalData.items[item_id]["equipment_slot"]
	if item_value:
		data["origin__usable"] = null
		data["origin__maximum_value"] = GlobalData.items[item_id]["maximum_value"]

	var drag_texture = TextureRect.new()
	drag_texture.expand = true
	drag_texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	drag_texture.set_texture(texture)
	drag_texture.rect_size = Vector2(64, 64)

	var control = Control.new()
	control.add_child(drag_texture)
	drag_texture.rect_position = -0.5 * drag_texture.rect_size
	set_drag_preview(control)
	
	return data

func can_drop_data(_position, data) -> bool:
	var can_drop_data_boolean: Array = []
	var target_item_slot = get_parent()
	data["target_panel"] = self.origin_panel
	memory_id = get_node("../../../../..").memory_id if data["target_panel"] == "ItemContainer" else ""
	data["target_dictionary"] = MenuData.get_dictionary(data["target_panel"])
	data["target_node"] = self
	data["target__equipment_slot"] = null
	
	if MenuData.split_button_node.pressed and data["origin_item_value"]:
		return false
	
	if data["target_dictionary"][target_item_slot.name]["item_id"]:
		if MenuData.split_button_node.pressed:
			return false
		
		data["target_item_icon"] = texture
		
		data["target_item_id"] = data["target_dictionary"][target_item_slot.name]["item_id"]
		data["target_item_stack"] = data["target_dictionary"][target_item_slot.name]["item_stack"]
		data["target_item_value"] = data["target_dictionary"][target_item_slot.name]["item_value"]
	else:
		data["target_item_icon"] = null
		
		data["target_item_id"] = null
		data["target_item_stack"] = null
		data["target_item_value"] = null
	
	if data["target_item_id"]:
		data["target__equipment_slot"] = GlobalData.items[data["target_item_id"]]["equipment_slot"]
	
	match data["origin_panel"]:
		"Inventory": 
			can_drop_data_boolean.append(true)
		"PlayerSheet":
			if data["target__equipment_slot"] == data["origin_node"].get_parent().name or data["target_item_id"] == null:
				can_drop_data_boolean.append(true)
			else:
				can_drop_data_boolean.append(false)
		"Manufacturer":
			can_drop_data_boolean.append(data["origin_node"].call("on_Manufacturer_can_drop_data", target_item_slot.name, data))
		"ItemContainer":
			can_drop_data_boolean.append(true)
		_:
			can_drop_data_boolean.append(false)
	
	match data["target_panel"]:
		"Inventory":
			can_drop_data_boolean.append(true)
		"PlayerSheet":
			if data["origin__equipment_slot"] == data["target_node"].get_parent().name:
				can_drop_data_boolean.append(true)
			else:
				can_drop_data_boolean.append(false)
		"Manufacturer":
			can_drop_data_boolean.append(call("on_Manufacturer_can_drop_data", target_item_slot.name, data))
		"ItemContainer":
			can_drop_data_boolean.append(true)
		_:
			can_drop_data_boolean.append(false)
	
	for boolean in can_drop_data_boolean:
		if boolean == false:
			return false
	return true

func drop_data(_position, data):
	var target_item_slot = get_parent()
	var origin_item_slot = data["origin_node"].get_parent()
	
	MenuData.update_item_slot_ui(data, origin_panel, origin_item_slot, target_item_slot)
	
	# When the player is dragging the item to its initial slot
	if origin_item_slot == target_item_slot:
		return
	
	# If the split button is pressed
	if MenuData.split_button_node.pressed:
		MenuData.split_item(data, origin_panel, origin_item_slot, target_item_slot)
		return
	
	# Update the origin item slot
	if data["target_item_id"] == data["origin_item_id"] and data["origin__usable"] != null and (data["target_item_stack"] + data["origin_item_stack"]) <= MenuData.MAX_STACK:
		data["origin_dictionary"][origin_item_slot.name]["item_id"] = null
		data["origin_dictionary"][origin_item_slot.name]["item_stack"] = null
		
		data["origin_node"].texture = null
		origin_item_slot.get_node("ItemQuantity").set_text("")
	else:
		data["origin_node"].texture = data["target_item_icon"]
		data["origin_dictionary"][origin_item_slot.name]["item_id"] = data["target_item_id"]
		data["origin_dictionary"][origin_item_slot.name]["item_stack"] = data["target_item_stack"]
		data["origin_dictionary"][origin_item_slot.name]["item_value"] = data["target_item_value"]
	
	if data["origin_panel"] == "PlayerSheet":
		data["origin_node"].call_deferred("on_PlayerSheet_drop_data", origin_item_slot, target_item_slot, data, false)
	
	if data["target_panel"] == "PlayerSheet":
		call_deferred("on_PlayerSheet_drop_data", origin_item_slot, target_item_slot, data, true)
	
	data["target_dictionary"][target_item_slot.name]["item_id"] = data["origin_item_id"]
	texture = data["origin_item_icon"]
	data["target_dictionary"][target_item_slot.name]["item_stack"] = data["origin_item_stack"]
	data["target_dictionary"][target_item_slot.name]["item_value"] = data["origin_item_value"]
	
	# Update the target item slot
	if data["target_item_id"] == data["origin_item_id"] and data["origin__usable"] != null and (data["target_item_stack"] + data["origin_item_stack"]) <= MenuData.MAX_STACK:
		var new_stack = data["target_item_stack"] + data["origin_item_stack"]
		data["target_dictionary"][target_item_slot.name]["item_stack"] = new_stack
		
		target_item_slot.get_node("ItemQuantity").set_text(str(new_stack))
		MenuData.emit_signal("RefreshMenuData")
		return
	
	MenuData.emit_signal("RefreshMenuData")

func _on_ItemIcon_gui_input(event):
	if event is InputEventScreenTouch and event.pressed:
		get_parent().color = Color("555555")
		
		if MenuData.use_button_node.pressed and not MenuData.split_button_node.pressed and not MenuData.delete_button_node.pressed:
			var used_node = get_parent()
			MenuData.use_item(origin_panel, used_node)
		elif MenuData.delete_button_node.pressed and not MenuData.use_button_node.pressed and not MenuData.split_button_node.pressed:
			var deleted_node = get_parent()
			MenuData.delete_item(origin_panel, deleted_node)
		else:
			pass
			
		# Show the tooltip of the item that was clicked
		if MenuData.statistics_node.has_node("Tooltip"):
			MenuData.statistics_node.get_node("Tooltip").free()
		else:
			pass
		var tooltip = MenuData.tooltip_tscn.instance()
		tooltip.item_slot = get_parent().name
		tooltip.origin_panel = origin_panel
		MenuData.statistics_node.call_deferred("add_child", tooltip)
		
	elif event is InputEventScreenTouch and not event.pressed:
		get_parent().color = Color("333333")
