extends ManufacturerMenu

var workbench_all_recipes: Dictionary = {
	"AllRecipes": {"InputSlot": {"item_id": "hickory_log", "item_stack": 2}, "OutputSlot": {"item_id": "hickory_plank", "item_stack": 1}},
	"AllRecipes2": {"InputSlot": {"item_id": "cumaru_log", "item_stack": 3}, "OutputSlot": {"item_id": "cumaru_plank", "item_stack": 1}},
	"AllRecipes3": {"InputSlot": {"item_id": "ipe_log", "item_stack": 4}, "OutputSlot": {"item_id": "ipe_plank", "item_stack": 1}}
}

func ready():
	input_slot_node = $Control/VBC/C/MC/HBC/InputSlot
	output_slot_node = $Control/VBC/C/MC/HBC/OutputSlot
	left_slot_node = $Control/VBC/C/MC/HBC
	right_slot_node = left_slot_node

func get_all_recipes() -> Dictionary:
	return workbench_all_recipes
