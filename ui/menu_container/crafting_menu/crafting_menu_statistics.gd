extends Control

export (PackedScene) var RecipeTexture

var item_id: String = ""

onready var crafting_menu_statistics = $MC/VBC/CR
onready var item_icon = $MC/VBC/C/MC/ItemIcon
onready var gc = $MC/VBC/C2/MC/GC
onready var craft_button = $MC/VBC/Craft

func _ready():
	display()

# Display the whole crafting tooltip
func display():
	craft_button.disabled = true
	gc.columns = 3
	var data: Dictionary = {}
	data["can_craft_bools"] = []
	data["item_id"] = item_id
	
	var icon = load("res://assets/images/items/%s" % GlobalData.items[item_id]["icon"])
	item_icon.set_texture(icon)
	
	crafting_menu_statistics.get_node("VBC/ItemName").set_text(GlobalData.items[item_id]["name"])
	var item_statistics = 1
	for i in PlayerData.statistics_data.keys():
		if GlobalData.items[item_id].has(i):
			var statistics_value = GlobalData.items[item_id][i]
			var statistics_texture = load("res://assets/icons/%s.png" % i)
			crafting_menu_statistics.get_node("VBC/HBC/HBC" + str(item_statistics) + "/Icon").set_texture(statistics_texture)
			crafting_menu_statistics.get_node("VBC/HBC/HBC" + str(item_statistics) + "/Statistics").set_text(str(statistics_value))
			
			item_statistics += 1
		else:
			pass
			
	for i in gc.get_children():
		i.queue_free()
		
	get_craft_data(data)
	
	if can_craft(data):
		craft_button.disabled = false

# Check if the player can craft it
func can_craft(data):
	for boolean in data["can_craft_bools"]:
		if boolean == false:
			return false
	return true

# Get the data of the item which is chosen to be crafted
func get_craft_data(data):
	if not GlobalData.items[item_id].has("recipe"):
		return
	
	for i in GlobalData.items[item_id]["recipe"].keys():
		var recipe_slot = RecipeTexture.instance()
		recipe_slot.rect_min_size = Vector2(98, 98)
		var avaliable_recipe_stack = get_total_stack(i)
		var required_recipe_stack = GlobalData.items[item_id]["recipe"][i]
		
		if avaliable_recipe_stack >= required_recipe_stack:
			data["can_craft_bools"].append(true)
		else:
			data["can_craft_bools"].append(false)
		
		# Update the UI
		var icon = load("res://assets/images/items/%s" % GlobalData.items[i]["icon"])
		recipe_slot.get_node("Icon").set_texture(icon)
		recipe_slot.get_node("Quantity").set_text("%s/%s" % [avaliable_recipe_stack, required_recipe_stack])
		recipe_slot.get_node("Quantity").visible = true
		
		# Change the color of the label depending on the accessablilty
		if avaliable_recipe_stack < required_recipe_stack:
			recipe_slot.get_node("Quantity").set("custom_colors/font_color", Color("ff0000"))
		else:
			recipe_slot.get_node("Quantity").set("custom_colors/font_color", Color("3eff00"))
			
		gc.add_child(recipe_slot, true)

# Get the total number of the item in the inventory
func get_total_stack(recipe_item_id) -> int:
	var total_stack: int = 0
	for item_slot in MenuData.inventory_data.keys():
		if MenuData.inventory_data[item_slot]["item_id"] == recipe_item_id and MenuData.inventory_data[item_slot]["item_stack"]:
			total_stack += MenuData.inventory_data[item_slot]["item_stack"]
	return total_stack

# Clear all the recipes that has been used during the crafting process
func clear_recipes() -> void:
	for i in GlobalData.items[item_id]["recipe"].keys():
		var remain_recipe_quantity = GlobalData.items[item_id]["recipe"][i]
		for item_slot in MenuData.inventory_data.keys():
			if MenuData.inventory_data[item_slot]["item_id"] == i:
				for _j in range(remain_recipe_quantity):
					if MenuData.inventory_data[item_slot]["item_stack"] and MenuData.inventory_data[item_slot]["item_stack"] > 1:
						MenuData.inventory_data[item_slot]["item_stack"] -= 1
						remain_recipe_quantity -= 1
					else:
						MenuData.inventory_data[item_slot]["item_id"] = null
						MenuData.inventory_data[item_slot]["item_stack"] = null
						remain_recipe_quantity -= 1
						break

# Craft the item
func _on_Craft_button_up():
	if MenuData.is_inventory_full():
		return
	for item_slot in MenuData.inventory_data.keys():
		if not MenuData.inventory_data[item_slot]["item_id"]:
			MenuData.inventory_data[item_slot]["item_id"] = item_id
			MenuData.inventory_data[item_slot]["item_stack"] = 1
			
			if GlobalData.items[item_id].has("maximum_value"):
				var new_value = GlobalData.items[item_id]["maximum_value"]
				MenuData.inventory_data[item_slot]["item_value"] = new_value
			clear_recipes()
			# Redisplay the whole crafting tootip again by updating it
			display()
			# Stop the for loop
			break
