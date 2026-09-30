extends Control
class_name ManufacturerMenu

export (String) var manufacturer_name
export (PackedScene) var ItemTexture

# Buttons
onready var show_all_recipes_button = $Control/VBC/HBC/ShowAllRecipes
onready var manufacture_button = $Control/VBC/C2/MC/HBC/Manufacture
# Labels
onready var product_name = $Control/VBC/C2/MC/HBC/Label
onready var title_name = $Control/VBC/HBC/TitleName
# Containers
onready var all_recipes_container = $Control/VBC/C/BaseControl/SC/HBC/AllRecipesContainer
onready var base_control = $Control/VBC/C/BaseControl
# Flexible nodes
onready var left_slot_node: Node
onready var input_slot_node: Node
onready var catalyst_slot_node: Node
onready var right_slot_node: Node
onready var output_slot_node: Node

var global_matched_all_recipes: Dictionary

func _ready():
	MenuData.connect("RefreshMenuData", self, "refresh_can_manufacture_data")
	call("ready")
	display()
	refresh_can_manufacture_data()

func display():
	title_name.set_text(manufacturer_name)
	MenuData.target_manufacturer_data["all_recipes"] = call("get_all_recipes")
	var item_slots = MenuData.target_manufacturer_data["item_slots"]
	for i in item_slots.keys():
		if item_slots[i]["item_id"]:
			var item_icon_node: Node = left_slot_node.get_node(i).get_node("ItemIcon") if i in ["InputSlot", "CatalystSlot"] else right_slot_node.get_node(i).get_node("ItemIcon")
			var item_stack_node: Node = left_slot_node.get_node(i).get_node("ItemQuantity") if i in ["InputSlot", "CatalystSlot"] else right_slot_node.get_node(i).get_node("ItemQuantity")
			var item_id = item_slots[i]["item_id"]
			var item_stack = item_slots[i]["item_stack"]
			
			var item_icon = load("res://assets/images/items/%s" % GlobalData.items[item_id]["icon"])
			item_icon_node.set_texture(item_icon)
			if item_stack and item_stack > 1:
				item_stack_node.set_text(str(item_stack))

func refresh_can_manufacture_data():
	var local_data: Dictionary = {}
	local_data["can_manufacture_data"] = get_can_manufacture_data()
	if MenuData.target_manufacturer_data["item_slots"]["InputSlot"]["item_id"]:
		product_name.set_text(GlobalData.items[global_matched_all_recipes["OutputSlot"]["item_id"]]["name"])
	else:
		product_name.set_text("")
	
	if can_manufacture(local_data):
		manufacture_button.disabled = false
	else:
		manufacture_button.disabled = true

# Check if the player has the required factors
func can_manufacture(local_data: Dictionary) -> bool:
	for boolean in local_data["can_manufacture_data"]:
		if boolean == false:
			return false
	return true

func compare_item_stack(origin_stack: int, target_stack: int) -> bool:
	if origin_stack >= target_stack:
		return true
	else:
		return false

# Also check if the player can manufacture the desired product
func CatalystSlot_get_manufacturer_data(InputSlot_item_id, matched_all_recipes: Dictionary, can_manufacture_data: Array):
	var CatalystSlot_item_id = MenuData.target_manufacturer_data["item_slots"]["CatalystSlot"]["item_id"]
		
	if InputSlot_item_id == null or CatalystSlot_item_id == null:
		can_manufacture_data.append(false)
		return
	
	var CatalystSlot_item_stack: int = MenuData.target_manufacturer_data["item_slots"]["CatalystSlot"]["item_stack"]
	var required_CatalystSlot_item_id: String = matched_all_recipes["CatalystSlot"][CatalystSlot_item_id]["item_id"]
	var required_CatalystSlot_item_stack: int = matched_all_recipes["CatalystSlot"][CatalystSlot_item_id]["item_stack"]
	
	if CatalystSlot_item_id == required_CatalystSlot_item_id:
		can_manufacture_data.append(compare_item_stack(CatalystSlot_item_stack, required_CatalystSlot_item_stack))

# Check if the player can manufacture the desired product
func get_can_manufacture_data() -> Array:
	var can_manufacture_data: Array = []
	
	for i in MenuData.target_manufacturer_data["all_recipes"].keys():
		var matched_all_recipes = MenuData.target_manufacturer_data["all_recipes"][i]
		var InputSlot_item_id = MenuData.target_manufacturer_data["item_slots"]["InputSlot"]["item_id"]
		
		if InputSlot_item_id == null:
			return [false]
		
		var OutputSlot_item_id = MenuData.target_manufacturer_data["item_slots"]["OutputSlot"]["item_id"]
		var InputSlot_item_stack: int = MenuData.target_manufacturer_data["item_slots"]["InputSlot"]["item_stack"]
		if InputSlot_item_id == matched_all_recipes["InputSlot"]["item_id"]:
			global_matched_all_recipes = matched_all_recipes
			if OutputSlot_item_id and (matched_all_recipes["OutputSlot"]["item_id"] != OutputSlot_item_id):
				return [false]
				
			if MenuData.target_manufacturer_data["item_slots"].has("CatalystSlot"):
				CatalystSlot_get_manufacturer_data(InputSlot_item_id, matched_all_recipes, can_manufacture_data)
			can_manufacture_data.append(compare_item_stack(InputSlot_item_stack, matched_all_recipes["InputSlot"]["item_stack"]))
	return can_manufacture_data

func produce(local_data: Dictionary):
	var dictionary: Dictionary = MenuData.get_dictionary("Manufacturer")

	# If true, it will add a single number of the item stack, and return
	if dictionary[output_slot_node.name]["item_stack"] and dictionary[output_slot_node.name]["item_stack"] >= 1:
		dictionary[output_slot_node.name]["item_stack"] += 1
		# Increase the number of the stack of it
		var added_stack = dictionary[output_slot_node.name]["item_stack"]
		output_slot_node.get_node("ItemQuantity").set_text(str(added_stack))
		return

	# Create a item
	dictionary[output_slot_node.name]["item_id"] = local_data["OutputSlot_item_id"]
	dictionary[output_slot_node.name]["item_stack"] = 1
	dictionary[output_slot_node.name]["item_value"] = null
	var item_icon = load("res://assets/images/items/%s" % GlobalData.items[local_data["OutputSlot_item_id"]]["icon"])
	output_slot_node.get_node("ItemIcon").set_texture(item_icon)
	output_slot_node.get_node("ItemQuantity").set_text("")

func start_production(local_data: Dictionary):
	# Clear the used materials
	for _a in range(local_data["InputSlot_item_stack"]):
		MenuData.delete_item("Manufacturer", input_slot_node)
	if local_data.has("CatalystSlot_item_id"):
		for _a in range(local_data["CatalystSlot_item_stack"]):
			MenuData.delete_item("Manufacturer", catalyst_slot_node)
	for _a in range(local_data["OutputSlot_item_stack"]):
		produce(local_data)

func _on_Manufacture_button_up():
	var local_data = {}
	for i in MenuData.target_manufacturer_data["all_recipes"].keys():
		var matched_all_recipes = MenuData.target_manufacturer_data["all_recipes"][i]
		var InputSlot_item_id: String = MenuData.target_manufacturer_data["item_slots"]["InputSlot"]["item_id"]
		
		if InputSlot_item_id == matched_all_recipes["InputSlot"]["item_id"]:
			local_data["InputSlot_item_id"] = InputSlot_item_id
			local_data["InputSlot_item_stack"] = matched_all_recipes["InputSlot"]["item_stack"]
			if MenuData.target_manufacturer_data["item_slots"].has("CatalystSlot"):
				local_data["CatalystSlot_item_id"] = matched_all_recipes["CatalystSlot"][MenuData.target_manufacturer_data["item_slots"]["CatalystSlot"]["item_id"]]["item_id"]
				local_data["CatalystSlot_item_stack"] = matched_all_recipes["CatalystSlot"][local_data["CatalystSlot_item_id"]]["item_stack"]
			local_data["OutputSlot_item_id"] = matched_all_recipes["OutputSlot"]["item_id"]
			local_data["OutputSlot_item_stack"] = matched_all_recipes["OutputSlot"]["item_stack"]
			
			start_production(local_data)
			refresh_can_manufacture_data()
			return
#	for i in MenuData.target_manufacturer_data["all_recipes"].keys():
#		var matched_all_recipes = MenuData.target_manufacturer_data["all_recipes"][i]
#		if MenuData.target_manufacturer_data["item_slots"]["InputSlot"]["item_id"] == matched_all_recipes["InputSlot"]["item_id"]:
#			clear_recipes(matched_all_recipes)
#
#			# Produce the item (k) times
#			for k in range(matched_all_recipes["OutputSlot"]["item_stack"]):
#				produce(matched_all_recipes)
#
#			can_manufacture()
#			return

func _on_ShowAllRecipes_button_up():
	base_control.visible = !base_control.visible
	for i in all_recipes_container.get_children():
		i.queue_free()

	for i in MenuData.target_manufacturer_data["all_recipes"].keys():
		var single_hbc: HBoxContainer = HBoxContainer.new()
		single_hbc.add_constant_override("separation", 16)
		var matched_all_recipes = MenuData.target_manufacturer_data["all_recipes"][i]

		var input_texture = ItemTexture.instance()
		input_texture.get_node("Icon").set_texture(load("res://assets/images/items/%s" % GlobalData.items[matched_all_recipes["InputSlot"]["item_id"]]["icon"]))
		input_texture.get_node("Quantity").set_text(str(matched_all_recipes["InputSlot"]["item_stack"]))
		input_texture.get_node("Quantity").visible = true
		input_texture.rect_min_size = Vector2(128, 128)
		single_hbc.add_child(input_texture, true)
		
		if MenuData.target_manufacturer_data["item_slots"].has("CatalystSlot"):
			var flame_texture = TextureRect.new()
			flame_texture.self_modulate = Color(0.8, 0.8, 0.8, 1)
			flame_texture.texture = load("res://assets/icons/flame.png")
			flame_texture.rect_min_size = Vector2(64, 64)
			flame_texture.expand = true
			flame_texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			single_hbc.add_child(flame_texture, true)
			
			var available_catalysts: Array = matched_all_recipes["CatalystSlot"].keys()
			var catalyst_texture = ItemTexture.instance()
			var catalyst_item_id: String = available_catalysts[randi() % available_catalysts.size()]
			catalyst_texture.get_node("Icon").set_texture(load("res://assets/images/items/%s" % GlobalData.items[matched_all_recipes["CatalystSlot"][catalyst_item_id]["item_id"]]["icon"]))
			catalyst_texture.get_node("Quantity").set_text(str(matched_all_recipes["CatalystSlot"][catalyst_item_id]["item_stack"]))
			catalyst_texture.get_node("Quantity").visible = true
			catalyst_texture.rect_min_size = Vector2(128, 128)
			single_hbc.add_child(catalyst_texture, true)
		
		var arrow_texture = TextureRect.new()
		arrow_texture.texture = load("res://assets/icons/right_arrow.png")
		arrow_texture.rect_min_size = Vector2(64,64)
		arrow_texture.expand = true
		arrow_texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		single_hbc.add_child(arrow_texture, true)

		var output_texture = ItemTexture.instance()
		output_texture.get_node("Icon").set_texture(load("res://assets/images/items/%s" % GlobalData.items[matched_all_recipes["OutputSlot"]["item_id"]]["icon"]))
		output_texture.rect_min_size = Vector2(128, 128)
		single_hbc.add_child(output_texture, true)

		all_recipes_container.add_child(single_hbc, true)
