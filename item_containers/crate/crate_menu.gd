extends ItemContainerMenu

onready var location: String = get_node("../../../../..").location_id

func iretate_through_item_slots(item_slots: Dictionary) -> void:
	for i in item_slots.keys():
		if item_slots[i]["item_id"] == null:
			item_slots[i]["item_id"] = GlobalData.get_random_item_id(location)

func generate() -> void:
	var item_slots: Dictionary = MenuData.menu_data["target_item_container_data"]["item_slots"]
	for _i in range(rand_range(8, 10)):
		iretate_through_item_slots(item_slots)
		
