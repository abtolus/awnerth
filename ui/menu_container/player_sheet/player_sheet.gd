extends Control

export (PackedScene) var EquipmentSlot

onready var player_sheet_statistics_ui = $VBC/VBC/PlayerSheetStatisticsUI
onready var left_equipment_slots = $VBC/HBC/VBC
onready var right_equipment_slots = $VBC/HBC/VBC2
onready var statistics_node = $VBC/VBC2/Statistics

var left_equipment_array: Array = ["MainHand", "RingFinger", "OffHand", "Backpack"]
var right_equipment_array: Array = ["Head", "Neck", "Chest", "Feet"]

func display(i, target_equipment_slots: Node) -> void:
	if MenuData.equipment_data[i]["item_id"]:
		var item_id = MenuData.equipment_data[i]["item_id"]
		var item_slot = target_equipment_slots.get_node(i)
		item_slot.get_node("ItemIcon").self_modulate = Color("ffffff")
		
		var _item_name = GlobalData.items[str(MenuData.equipment_data[i]["item_id"])]["name"]
		var item_icon = load("res://assets/images/items/%s" % GlobalData.items[str(MenuData.equipment_data[i]["item_id"])]["icon"])
		var item_value = MenuData.equipment_data[i]["item_value"]
		item_slot.get_node("ItemIcon").set_texture(item_icon)
		if item_value:
			var item_maximum_value = GlobalData.items[item_id]["maximum_value"]
			item_slot.get_node("ItemValue").max_value = item_maximum_value
			item_slot.get_node("ItemValue").value = item_value
			item_slot.get_node("ItemValue").visible = !item_slot.get_node("ItemValue").visible
	else:
		var default_icon = load("res://assets/images/silhouettes/%s.png" % i)
		target_equipment_slots.get_node(i).get_node("ItemIcon").set_texture(default_icon)
		target_equipment_slots.get_node(i).get_node("ItemIcon").self_modulate = Color("000000")

# Display the number of columns and rows of the item slots in the inventory UI.
func _ready():
	MenuData.connect("RefreshMenuData", self, "attempt_to_showcase")
	PlayerData.connect("RefreshUI", self, "refresh_player_sheet_statistics_ui")
	attempt_to_showcase()
	refresh_player_sheet_statistics_ui()
	
	for i in MenuData.equipment_data.keys():
		if i in left_equipment_array:
			display(i, left_equipment_slots)
		elif i in right_equipment_array:
			display(i, right_equipment_slots)

func refresh_player_sheet_statistics_ui():
	var health_node: Node = player_sheet_statistics_ui.get_node("MC/VBC/HBC/HBC/TP")
	var shield_node: Node = player_sheet_statistics_ui.get_node("MC/VBC/HBC/HBC2/TP")
	var food_satiation_node: Node = player_sheet_statistics_ui.get_node("MC/VBC/HBC2/HBC/TP")
	var water_satisfaction_node: Node = player_sheet_statistics_ui.get_node("MC/VBC/HBC2/HBC2/TP")
	
	health_node.value = PlayerData.statistics_data["health"]
	shield_node.value = PlayerData.statistics_data["shield"]
	if MenuData.equipment_data["OffHand"]["item_id"]:
		shield_node.max_value = GlobalData.items[MenuData.equipment_data["OffHand"]["item_id"]]["shield"]
	food_satiation_node.value = PlayerData.statistics_data["food_satiation"]
	water_satisfaction_node.value = PlayerData.statistics_data["water_satisfaction"]

func attempt_to_showcase():
	if statistics_node.has_node("PlayerStatistics"):
		statistics_node.get_node("PlayerStatistics").free()
	else:
		pass
	var player_statistics = MenuData.player_statistics_tscn.instance()
	statistics_node.call_deferred("add_child", player_statistics)
