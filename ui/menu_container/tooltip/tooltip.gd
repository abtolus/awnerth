extends ColorRect

var item_slot: String
var origin_panel: String

func _ready():
	var dictionary = MenuData.get_dictionary(origin_panel)
	showcase(dictionary)
	
func showcase(data: Dictionary):
	var statistics_index = 1
	var item_id = data[item_slot]["item_id"]
	if not item_id:
		queue_free()
		return
	
	get_node("NPR/VBC/MC/ItemName").set_text(GlobalData.items[item_id]["name"])
	
	for i in PlayerData.statistics_data.keys():
		if not GlobalData.items[item_id].has(i):
			pass
		else:
			var statistics_value: float = GlobalData.items[item_id][i]
			var statistics_icon = load("res://assets/icons/%s.png" % i)
			get_node("NPR/VBC/HBC/C" + str(statistics_index) + "/HBC/Icon").set_texture(statistics_icon)
			if i in ["damage_reduction", "speed"]:
				var percentage: String = "%"
				get_node("NPR/VBC/HBC/C" + str(statistics_index) + "/HBC/Statistics").set_text("%s%s" % [str(statistics_value), percentage])
			else:
				get_node("NPR/VBC/HBC/C" + str(statistics_index) + "/HBC/Statistics").set_text(str(statistics_value))
			
			get_node("NPR/VBC/HBC/C" + str(statistics_index) + "/ColorRect").color = Color("333333")
			if GlobalData.items[item_id]["equipment_slot"] and origin_panel != "PlayerSheet":
				var statistics_difference: float = get_statistics_difference(item_id, i, statistics_value)
				get_node("NPR/VBC/HBC/C" + str(statistics_index) + "/HBC/Difference").set_text(" " + str(statistics_difference))
				
				get_node("NPR/VBC/HBC/C" + str(statistics_index) + "/HBC/Difference").set("custom_colors/font_color",
				MenuData.get_correct_color(statistics_difference))
				get_node("NPR/VBC/HBC/C" + str(statistics_index) + "/HBC/Difference").set("custom_colors/font_color",
				MenuData.get_correct_color(statistics_difference))
			statistics_index += 1

# Return the i difference between PlayerSheet and other menus
func get_statistics_difference(item_id: String, i: String, statistics_value: float):
	var statistics_difference: float
	var equipment_slot = GlobalData.items[item_id]["equipment_slot"]
	
	if MenuData.equipment_data[equipment_slot]["item_id"]:
		var compared_item_id = MenuData.equipment_data[equipment_slot]["item_id"]
		var compared_statistics_value = GlobalData.items[compared_item_id][i]
		statistics_difference =  statistics_value - compared_statistics_value if i in ["damage", "shield", "speed"] else compared_statistics_value - statistics_value
	else:
		if i in ["damage"]:
			statistics_difference =  statistics_value - PlayerData.default_statistics_data[i]
		elif i in ["fire_rate"]:
			statistics_difference = PlayerData.default_statistics_data[i] - statistics_value
		else:
			statistics_difference = statistics_value
	return statistics_difference
