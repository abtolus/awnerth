extends Node

var global_data_tres
var location_data: Dictionary = {
	"home": {"name": "Home", "description":
		"A safe haven or a comfort zone where you can relax and chill out with absolute peace and freedom and recover some health or shield."
	},
	"ipe_wood": {"name": "Ipe Wood", "description":
		"A woodland occupied by trees of Ipe, also called Brazillian walnut, known for its beautiful brown and amber tones as well as its durability.",
	"resource_data": {"Epic": ["ipe_plank"], "Rare": ["tiger_hide"],
	"Uncommon": ["ipe_log", "red_potion"], "Common": ["bread", "pork", "egg", "blue_potion", "apple"]},
	},
	"cumaru_grove": {"name": "Cumaru Grove", "description":
		"Not a mangrove but a grove of Cumaru, Brazilian teak, which has excellent durability and weathering properties.",
	"resource_data": {"Epic": ["cumaru_plank"], "Rare": ["wolf_hide"],
	"Uncommon": ["cumaru_log", "red_potion"], "Common": ["bread", "beef", "egg", "blue_potion", "apple"]}
	},
	"hickory_copses": {"name": "Hickory Copses", "description":
		"A temperate or subtropical forest that has been a place for the copse of Hickories, which are wind-pollinated and self-incompatible.",
	"resource_data": {"Epic": ["hickory_plank"], "Rare": ["deer_hide"],
	"Uncommon": ["apple"], "Common": ["apple"]}
	},
	"hostel": {"name": "Hostel", "description":
		"As a hotel can provide the guest with an outstanding service, this hostel could do so, but by unknowns since it's been invaded.",
	"resource_data": {"Epic": ["ipe_plank", "silver_bar"], "Rare": ["deer_hide", "fieldstone"],
	"Uncommon": ["red_potion"], "Common": ["bread", "sausage", "egg", "blue_potion"]}
	},
	"blockhouse": {"name": "Blockhouse", "description":
		"As a hotel can provide the guest with an outstanding service, this hostel could do so, but by unknowns since it's been invaded.",
	"resource_data": {"Epic": ["ipe_plank", "silver_bar"], "Rare": ["deer_hide", "fieldstone"],
	"Uncommon": ["red_potion"], "Common": ["bread", "sausage", "egg", "blue_potion"]}
	},
	"fieldstone_ridge": {"name": "Fieldstone Ridge", "description": 
		"An abandoned town, located on the ridge of fieldstone, was once an essential mine community where iron ores are mostly extracted.",
	"resource_data": {"Epic": ["iron_bar"],"Rare": ["fieldstone"],
	"Uncommon": ["iron_ore", "red_potion"], "Common": ["bread", "fish", "egg", "blue_potion", "apple"]}
	},
	"marble_crag": {"name": "Marble Crag", "description":
		"On this crag of marble, a metamorphic rock consisting of carbonate minerals, was just a forgotten region in which copper ores are often found.",
	"resource_data": {"Epic": ["copper_bar"], "Rare": ["marble"],
	"Uncommon": ["copper_ore", "red_potion"], "Common": ["bread", "beef", "egg", "blue_potion", "apple"]}
	},
	"granite_steep": {"name": "Granite Steep", "description":
		"A place surrounded by less steep mountain ranges of granite, a coarse-grained intrusive igneous rock, was the mining place of silver ores",
	"resource_data": {"Epic": ["silver_bar"], "Rare": ["granite"],
	"Uncommon": ["silver_ore", "red_potion"],"Common": ["bread", "pork", "egg", "blue_potion", "apple"]}
	}
}
var items: Dictionary
var cosmetics: Dictionary
var rarity_data: Dictionary = {
	"Epic": {"name": "Epic", "color": "a020f0", "chance": 10},
	"Rare": {"name": "Rare", "color": "0000ff", "chance": 25},
	"Uncommon": {"name": "Uncommon", "color": "008000", "chance": 30},
	"Common": {"name": "Common", "color": "808080", "chance": 35}
}
var static_entity_data: Dictionary = {
	"panzer": {"chance": 5}, "assassin": {"chance": 15}, "raider": {"chance": 30}, "burglar": {"chance": 50}
}
var global_data: Dictionary = {
	"setting": null, "day_and_night": null
}
var GLOBAL_DATA_TRES_PATH: String = "user://global_data_tres"

func _ready():
	items = read_from_JSON("res://assets/json/item_data.json")
	cosmetics = read_from_JSON("res://assets/json/wardrobe_data.json")
	load_data()
	OS.set_window_size(global_data["setting"]["resolution"])

func read_from_JSON(path):
	var file = File.new()
	if file.file_exists(path):
		file.open(path, File.READ)
		var data = parse_json(file.get_as_text())
		file.close()
		return data
	else:
		printerr("Invalid path was given!")

func get_random_item_id(location):
	var item_rarity = get_item_rarity()
	var item_id = get_item_id(location, item_rarity)
	return item_id

func get_item_rarity():
	var item_rarity
	randomize()
	var rarity_roll = randi() % 100 + 1
	for i in rarity_data.keys():
		if rarity_roll <= rarity_data[i]["chance"]:
			item_rarity = i
			return item_rarity
		else:
			rarity_roll -= rarity_data[i]["chance"]

func get_item_id(location, item_rarity):
	var item_id
	var item_list = GlobalData.location_data[location]["resource_data"][item_rarity]
	randomize()
	item_id = item_list[randi() % item_list.size()]
	return item_id

func on_Respawn_pressed() -> void:
	reset_everything()

func reset_everything() -> void:
	for i in MenuData.inventory_data.keys():
		MenuData.inventory_data[i]["item_id"] = null
		MenuData.inventory_data[i]["item_stack"] = null
		MenuData.inventory_data[i]["item_value"] = null
		
	for i in MenuData.equipment_data.keys():
		MenuData.equipment_data[i]["item_id"] = null
		MenuData.equipment_data[i]["item_stack"] = null
		MenuData.equipment_data[i]["item_value"] = null
		
	for i in PlayerData.statistics_data.keys():
		PlayerData.statistics_data[i] = PlayerData.default_statistics_data[i]
			
	save_data()
	MenuData.save_data()
	PlayerData.save_data()

func load_data() -> void:
	if GlobalDataTres.data_exists(GLOBAL_DATA_TRES_PATH):
		global_data_tres = GlobalDataTres.load_data(GLOBAL_DATA_TRES_PATH) as GlobalDataTres
	else:
		global_data_tres = GlobalDataTres.new()
		global_data_tres.save_data(GLOBAL_DATA_TRES_PATH)
	global_data["setting"] = global_data_tres.static_global_data["setting"]
	global_data["day_and_night"] = global_data_tres.static_global_data["day_and_night"]

func save_data() -> void:
	global_data_tres.static_global_data["day_and_night"] = global_data["day_and_night"]
	global_data_tres.static_global_data["setting"].merge(global_data["setting"], true)
	global_data_tres.save_data(GLOBAL_DATA_TRES_PATH)

func get_split_id(string: String, delimiter: String = "/", max_split: int = 1, index: int = 1) -> String:
	var split_data: Array = string.split("%s" % delimiter, true, max_split)
	return split_data[index] if split_data.size() > 1 else split_data[0]

func get_by_param(data: Dictionary, param: Array):
	for i in data.keys():
		if data[i][param[0]] == param[1]:
			return data[i][param[2]]
	return 0
