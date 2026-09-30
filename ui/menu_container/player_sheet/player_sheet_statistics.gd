extends ColorRect

func _ready():
	var player_statistics: Array = ["damage", "fire_rate", "damage_reduction", "speed"]
	showcase(player_statistics)

func showcase(array: Array):
	var statistics_index = 1
	
	for i in range(array.size()):
		var statistics_value: float = PlayerData.statistics_data[array[i]]
		var statistics_icon = load("res://assets/icons/%s.png" % array[i])
		
		get_node("MC/HBC/C" + str(statistics_index) + "/HBC/Icon").set_texture(statistics_icon)
		get_node("MC/HBC/C" + str(statistics_index) + "/HBC/Label").set_text(str(statistics_value))
		get_node("MC/HBC/C" + str(statistics_index) + "/ColorRect").color = Color("333333")
		statistics_index += 1
