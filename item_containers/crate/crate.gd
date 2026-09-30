extends ItemContainer

onready var crate_menu_tscn: PackedScene = preload("res://item_containers/crate/crate_menu.tscn")
onready var location: String = get_node("../..").location_id

var crate_data: Dictionary = {"slots": 25}

func refresh_crate_menu() -> void:
	target_menu_tscn = crate_menu_tscn
	
	for _i in range(rand_range(5, 8)):
		var new_item_id: String = GlobalData.get_random_item_id(location)

