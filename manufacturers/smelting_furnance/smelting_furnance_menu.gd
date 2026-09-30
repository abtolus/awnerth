extends ManufacturerMenu

var smelting_furnance_all_recipes: Dictionary = {
	"AllRecipes": {"InputSlot": {"item_id": "iron_ore", "item_stack": 2}, "CatalystSlot": {"charcoal": {"item_id": "charcoal", "item_stack": 4}}, "OutputSlot": {"item_id": "iron_bar", "item_stack": 1}},
	"AllRecipes2": {"InputSlot": {"item_id": "copper_ore", "item_stack": 3}, "CatalystSlot": {"charcoal": {"item_id": "charcoal", "item_stack": 6}}, "OutputSlot": {"item_id": "copper_bar", "item_stack": 1}},
	"AllRecipes3": {"InputSlot": {"item_id": "silver_ore", "item_stack": 4}, "CatalystSlot": {"charcoal": {"item_id": "charcoal", "item_stack": 8}}, "OutputSlot": {"item_id": "silver_bar", "item_stack": 1}},
	"AllRecipes4": {"InputSlot": {"item_id": "gold_ore", "item_stack": 5}, "CatalystSlot": {"charcoal": {"item_id": "charcoal", "item_stack": 10}}, "OutputSlot": {"item_id": "gold_bar", "item_stack": 1}}
}

func ready():
	input_slot_node = $Control/VBC/C/MC/HBC/VBC/InputSlot
	output_slot_node = $Control/VBC/C/MC/HBC/Control/OutputSlot
	left_slot_node = $Control/VBC/C/MC/HBC/VBC
	right_slot_node = $Control/VBC/C/MC/HBC/Control

func get_all_recipes() -> Dictionary:
	return smelting_furnance_all_recipes
