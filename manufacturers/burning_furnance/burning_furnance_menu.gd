extends ManufacturerMenu

var burning_furnance_all_recipes: Dictionary = {
	"AllRecipes": {"InputSlot": {"item_id": "hickory_log", "item_stack": 4}, "CatalystSlot": {
		"charcoal": {"item_id": "charcoal", "item_stack": 1},
		"hickory_log": {"item_id": "hickory_log", "item_stack": 2}
	}, "OutputSlot": {"item_id": "charcoal", "item_stack": 2}},
	"AllRecipes2": {"InputSlot": {"item_id": "hickory_plank", "item_stack": 2}, "CatalystSlot": {
		"charcoal": {"item_id": "charcoal", "item_stack": 1}
	}, "OutputSlot": {"item_id": "charcoal", "item_stack": 4}}
}

func ready():
	input_slot_node = $Control/VBC/C/MC/HBC/VBC/InputSlot
	catalyst_slot_node = $Control/VBC/C/MC/HBC/VBC/CatalystSlot
	output_slot_node = $Control/VBC/C/MC/HBC/Control/OutputSlot
	left_slot_node = $Control/VBC/C/MC/HBC/VBC
	right_slot_node = $Control/VBC/C/MC/HBC/Control

func get_all_recipes() -> Dictionary:
	return burning_furnance_all_recipes
