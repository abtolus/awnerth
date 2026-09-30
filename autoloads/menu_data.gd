extends Node

# Most important signals
signal RefreshMenuData

var menu_data_tres

var use_button_node: Node
var split_button_node: Node
var delete_button_node: Node
var statistics_node: Node

onready var tooltip_tscn: PackedScene = preload("res://ui/menu_container/tooltip/tooltip.tscn")
onready var player_statistics_tscn: PackedScene = preload("res://ui/menu_container/player_sheet/player_sheet_statistics.tscn")

const MAX_STACK: int = 32
var inventory_data: Dictionary = {
	"InventorySlot": null, "InventorySlot2": null, "InventorySlot3": null, "InventorySlot4": null, "InventorySlot5": null,
	"InventorySlot6": null, "InventorySlot7": null,"InventorySlot8": null, "InventorySlot9": null, "InventorySlot10": null,
	"InventorySlot11": null, "InventorySlot12": null, "InventorySlot13": null, "InventorySlot14": null, "InventorySlot15": null,
	"InventorySlot16": null, "InventorySlot17": null, "InventorySlot18": null, "InventorySlot19": null, "InventorySlot20": null,
	"InventorySlot21": null, "InventorySlot22": null, "InventorySlot23": null, "InventorySlot24": null, "InventorySlot25": null
}
var equipment_data: Dictionary = {
	"Head": null, "Neck": null, "Chest": null, "Feet": null, "MainHand": null, "RingFinger": null, "OffHand": null, "Backpack": null,
}
var target_item_container_data: Dictionary = {"item_container_id": null, "item_slots": null}
var target_manufacturer_data: Dictionary = {"manufacturer_id": null, "item_slots": null, "all_recipes": null}
var menu_data: Dictionary = {"inventory_data": inventory_data, "equipment_data": equipment_data, "target_item_container_data": target_item_container_data, "target_manufacturer_data": target_manufacturer_data}
var MENU_DATA_TRES_PATH: String = "user://menu_data_tres"

func _ready():
	emit_signal("RefreshMenuData")
	load_data()

func is_inventory_full() -> bool:
	for i in inventory_data.keys():
		if inventory_data[i]["item_id"] == null:
			return false
	return true

func destroy_equipped_item(a: String) -> void:
	for i in PlayerData.statistics_data.keys():
		if MenuData.equipment_data[a]["item_id"] and GlobalData.items[MenuData.equipment_data[a]["item_id"]].has(i):
			PlayerData.statistics_data[i] -= GlobalData.items[MenuData.equipment_data[a]["item_id"]][i]
	MenuData.equipment_data[a]["item_id"] = null
	MenuData.equipment_data[a]["item_value"] = null

func decrease_equipped_items(equipment_array: Array) -> void:
	for i in equipment_array:
		if MenuData.equipment_data[i]["item_id"] and MenuData.equipment_data[i]["item_value"] > 1:
			MenuData.equipment_data[i]["item_value"] -= 1
		else:
			destroy_equipped_item(i)

func load_data() -> void:
	if MenuDataTres.data_exists(MENU_DATA_TRES_PATH):
		menu_data_tres = MenuDataTres.load_data(MENU_DATA_TRES_PATH) as MenuDataTres
	else:
		menu_data_tres = MenuDataTres.new()
		menu_data_tres.save_data(MENU_DATA_TRES_PATH)
	
	menu_data["inventory_data"].merge(menu_data_tres.static_menu_data["inventory_data"], true)
	menu_data["equipment_data"].merge(menu_data_tres.static_menu_data["equipment_data"], true)

func save_data() -> void:
	menu_data_tres.static_menu_data["inventory_data"] = menu_data["inventory_data"]
	menu_data_tres.static_menu_data["equipment_data"] = menu_data["equipment_data"]
	if menu_data["target_item_container_data"]["item_container_id"]:
		MenuData.menu_data_tres.static_menu_data["item_container_database"][MenuData.target_item_container_data["item_container_id"]]["item_slots"] = MenuData.menu_data["target_item_container_data"]["item_slots"]
	if menu_data["target_manufacturer_data"]["manufacturer_id"]:
		MenuData.menu_data_tres.static_menu_data[MenuData.target_manufacturer_data["manufacturer_id"]].merge(MenuData.menu_data["target_manufacturer_data"], true)
	menu_data_tres.save_data(MENU_DATA_TRES_PATH)

func unequip_item(k, origin_id, target_id) -> void:
	if target_id and GlobalData.items[target_id].has(k):
		if k in ["damage", "fire_rate"]:
			PlayerData.statistics_data[k] = GlobalData.items[target_id][k]
		else:
			PlayerData.statistics_data[k] -= GlobalData.items[origin_id][k]
			PlayerData.statistics_data[k] += GlobalData.items[target_id][k]
	elif not target_id and GlobalData.items[origin_id].has(k):
		if k in ["damage", "fire_rate"]:
			PlayerData.statistics_data[k] = PlayerData.default_statistics_data[k]
		else:
			PlayerData.statistics_data[k] -= GlobalData.items[origin_id][k]

func equip_item(k, origin_id, target_id) -> void:
	if k in ["damage", "fire_rate"]:
		PlayerData.statistics_data[k] = GlobalData.items[origin_id][k]
		return
		
	if target_id:
		PlayerData.statistics_data[k] -= GlobalData.items[target_id][k]
		PlayerData.statistics_data[k] += GlobalData.items[origin_id][k]
	else:
		PlayerData.statistics_data[k] += GlobalData.items[origin_id][k]

# Setter functions
func set_statistics_data(origin_id, target_id, is_equipped: bool):
	for k in PlayerData.statistics_data.keys():
		if is_equipped and GlobalData.items[origin_id].has(k):
			equip_item(k, origin_id, target_id)
		elif not is_equipped:
			unequip_item(k, origin_id, target_id)
	PlayerData.emit_signal("RefreshUI")

# Getter functiions
func get_dictionary(panel: String) -> Dictionary:
	var dictionary: Dictionary
	match panel:
		"Inventory":
			dictionary = inventory_data
		"PlayerSheet":
			dictionary = equipment_data
		"Manufacturer":
			dictionary = target_manufacturer_data["item_slots"]
		"ItemContainer":
			dictionary = target_item_container_data["item_slots"]
	return dictionary

func update_item_slot_ui(data: Dictionary, origin_panel: String, origin_node: Node, target_node: Node) -> void:
	
	# Update the origin node
	if data["target_item_stack"] and data["target_item_stack"] > 1:
		origin_node.get_node("ItemQuantity").set_text(str(data["target_item_stack"])) 
	else:
		if origin_panel != "PlayerSheet":
			origin_node.get_node("ItemQuantity").set_text("")
	
	if data["origin_item_value"]:
		# Value to Value
		if data["target_item_value"]:
			origin_node.get_node("ItemValue").value = data["target_item_value"]
			origin_node.get_node("ItemValue").max_value = GlobalData.items[data["target_item_id"]]["maximum_value"]
		# Value to Null
		else:
			origin_node.get_node("ItemValue").value = 0
			origin_node.get_node("ItemValue").visible = false
	else:
		# Null to Value
		if data["target_item_value"]:
			origin_node.get_node("ItemValue").value = data["target_item_value"]
			origin_node.get_node("ItemValue").max_value = GlobalData.items[data["target_item_id"]]["maximum_value"]
			origin_node.get_node("ItemValue").visible = true
	
	
	# Update the target node
	if data["origin_item_stack"] and data["origin_item_stack"] > 1:
		target_node.get_node("ItemQuantity").set_text(str(data["origin_item_stack"])) 
	else:
		if origin_panel != "PlayerSheet":
			target_node.get_node("ItemQuantity").set_text("")
	
	if data["origin_item_value"]:
		# Value to Value
		if data["target_item_value"]:
			target_node.get_node("ItemValue").value = data["origin_item_value"]
			target_node.get_node("ItemValue").max_value = GlobalData.items[data["origin_item_id"]]["maximum_value"]
			target_node.get_node("ItemValue").visible = true
		# Value to Null
		else:
			target_node.get_node("ItemValue").value = data["origin_item_value"]
			target_node.get_node("ItemValue").max_value = GlobalData.items[data["origin_item_id"]]["maximum_value"]
			target_node.get_node("ItemValue").visible = true
	else:
		# Null to Value
		if data["target_item_value"]:
			target_node.get_node("ItemValue").value = 0
			target_node.get_node("ItemValue").visible = false

func use_item(panel: String, used_node: Node) -> void:
	var dictionary = get_dictionary(panel)
	
	if dictionary[used_node.name]["item_stack"] == null or GlobalData.items[dictionary[used_node.name]["item_id"]]["usable"] == false:
		return
	
	var item_id = dictionary[used_node.name]["item_id"]
	# Update the health of the player
	if GlobalData.items[item_id].has("health"):
		var health = GlobalData.items[item_id]["health"]
		PlayerData.increase_value("health", health)
	# Update the water satisfaction of the player
	if GlobalData.items[item_id].has("water_satisfaction"):
		var water_satisfaction = GlobalData.items[item_id]["water_satisfaction"]
		PlayerData.increase_value("water_satisfaction", water_satisfaction)
	# Update the food satiation of the player
	if GlobalData.items[item_id].has("food_satiation"):
		var food_satiation = GlobalData.items[item_id]["food_satiation"]
		PlayerData.increase_value("food_satiation", food_satiation)
	
	if dictionary[used_node.name]["item_id"] and dictionary[used_node.name]["item_stack"] < 2:
		dictionary[used_node.name]["item_id"] = null
		dictionary[used_node.name]["item_stack"] = null
		
		used_node.get_node("ItemIcon").set_texture(null)
		return
	
	# Reove an used item by individually
	dictionary[used_node.name]["item_stack"] -= 1
	var reduced_stack = dictionary[used_node.name]["item_stack"]
	if reduced_stack > 1:
		used_node.get_node("ItemQuantity").set_text(str(reduced_stack))
	else:
		used_node.get_node("ItemQuantity").set_text("")

func split_item(data: Dictionary, panel: String,  origin_node: Node, target_node: Node) -> void:
	if data["origin_item_stack"] < 2:
		return
	var dictionary = get_dictionary(panel)
	
	var split_amount = int(dictionary[origin_node.name]["item_stack"] / 2)
	dictionary[origin_node.name]["item_stack"] = data["origin_item_stack"] - split_amount
	dictionary[target_node.name]["item_id"] = data["origin_item_id"]
	dictionary[target_node.name]["item_stack"] = split_amount
	
	target_node.get_node("ItemIcon").set_texture(data["origin_item_icon"])
	
	if data["origin_item_stack"] - split_amount > 1:
		origin_node.get_node("ItemQuantity").set_text(str(data["origin_item_stack"] - split_amount))
	else:
		origin_node.get_node("ItemQuantity").set_text("")
		
	if split_amount > 1:
		target_node.get_node("ItemQuantity").set_text(str(split_amount))
	else:
		target_node.get_node("ItemQuantity").set_text("")

func delete_item(panel: String, deleted_node: Node) -> void:
	var dictionary: Dictionary = get_dictionary(panel)
	
	# If true, it will remove a single number of the item stack, and return
	if dictionary[deleted_node.name]["item_stack"] and dictionary[deleted_node.name]["item_stack"] > 1:
		dictionary[deleted_node.name]["item_stack"] -= 1
		
		# Reduce the number of the stack of it
		var reduced_stack = dictionary[deleted_node.name]["item_stack"]
		if reduced_stack > 1:
			deleted_node.get_node("ItemQuantity").set_text(str(reduced_stack))
		else:
			deleted_node.get_node("ItemQuantity").set_text("")
		return
		
	# Change the value to null
	dictionary[deleted_node.name]["item_id"] = null
	
	# If there is value, change it to null
	if dictionary[deleted_node.name]["item_stack"]:
		dictionary[deleted_node.name]["item_stack"] = null
	elif dictionary[deleted_node.name]["item_value"]:
		dictionary[deleted_node.name]["item_value"] = null
		deleted_node.get_node("ItemValue").visible = !get_node("../ItemValue").visible
		
	# Change the UI
	deleted_node.get_node("ItemIcon").set_texture(null)
	deleted_node.get_node("ItemQuantity").set_text("")
	deleted_node.get_node("ItemValue").value = 0

# Return the corresponding color
func get_correct_color(value: float, is_white: bool = false) -> Color:
	if is_white:
		return Color("ffffff") if value > 0 else Color("ff0000")
	return Color("3eff00") if value > 0 else Color("ff0000")

func create_item_container_menu(prefix: String, slot_quantity: int = 30) -> Dictionary:
	var new_item_container_data: Dictionary = {}
	var memory_address: int = 100
	for _i in range(slot_quantity):
		new_item_container_data["%s%d" % [prefix, memory_address]] = {"item_id": null, "item_stack": null, "item_value": null}
		memory_address += 1
	return {"item_slots": new_item_container_data}
#
#func create_item_container_data(item_container_slot_prefix: String) -> Dictionary:
#	var new_item_slots: Dictionary = {}
#	for i in range(30):
#		if i == 0:
#			new_item_slots["%s" % item_container_slot_prefix] = {"item_id": null, "item_stack": null, "item_value": null}
#		else:
#			i += 1
#			new_item_slots["%s%d" % [item_container_slot_prefix, i]] = {"item_id": null, "item_stack": null, "item_value": null}
#	return {"item_slots": new_item_slots}
#
#func create_new_data(memory_id: String, slots: int) -> Dictionary:
#	var new_data: Dictionary = {}
#	for i in range(slots):
#		new_data["ItemContainerSlot%d" % i] = {"item_id": null, "item_stack": null, "item_value": null}
#	return new_data
