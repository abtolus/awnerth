class_name MenuDataTres
extends DataTres

var inventory_data: Dictionary = {
	"InventorySlot": {"item_id": null, "item_stack": null, "item_value": null}, "InventorySlot2": {"item_id": null, "item_stack": null, "item_value": null}, "InventorySlot3": {"item_id": null, "item_stack": null, "item_value": null},
	"InventorySlot4": {"item_id": null, "item_stack": null, "item_value": null}, "InventorySlot5": {"item_id": null, "item_stack": null, "item_value": null}, "InventorySlot6": {"item_id": null, "item_stack": null, "item_value": null},
	"InventorySlot7": {"item_id": null, "item_stack": null, "item_value": null},"InventorySlot8": {"item_id": null, "item_stack": null, "item_value": null}, "InventorySlot9": {"item_id": null, "item_stack": null, "item_value": null},
	"InventorySlot10": {"item_id": null, "item_stack": null, "item_value": null}, "InventorySlot11": {"item_id": null, "item_stack": null, "item_value": null}, "InventorySlot12": {"item_id": null, "item_stack": null, "item_value": null},
	"InventorySlot13": {"item_id": null, "item_stack": null, "item_value": null}, "InventorySlot14": {"item_id": null, "item_stack": null, "item_value": null}, "InventorySlot15": {"item_id": null, "item_stack": null, "item_value": null},
	"InventorySlot16": {"item_id": null, "item_stack": null, "item_value": null}, "InventorySlot17": {"item_id": null, "item_stack": null, "item_value": null}, "InventorySlot18": {"item_id": null, "item_stack": null, "item_value": null},
	"InventorySlot19": {"item_id": null, "item_stack": null, "item_value": null}, "InventorySlot20": {"item_id": null, "item_stack": null, "item_value": null}, "InventorySlot21": {"item_id": null, "item_stack": null, "item_value": null},
	"InventorySlot22": {"item_id": null, "item_stack": null, "item_value": null}, "InventorySlot23": {"item_id": null, "item_stack": null, "item_value": null}, "InventorySlot24": {"item_id": null, "item_stack": null, "item_value": null},
	"InventorySlot25": {"item_id": null, "item_stack": null, "item_value": null}
}
var equipment_data: Dictionary = {
	"Head": {"item_id": null, "item_stack": null, "item_value": null}, "Neck": {"item_id": null, "item_stack": null, "item_value": null}, "Chest": {"item_id": null, "item_stack": null, "item_value": null}, "Feet": {"item_id": null, "item_stack": null, "item_value": null},
	"MainHand": {"item_id": null, "item_stack": null, "item_value": null}, "RingFinger": {"item_id": null, "item_stack": null, "item_value": null}, "OffHand": {"item_id": null, "item_stack": null, "item_value": null}, "Backpack": {"item_id": null, "item_stack": null, "item_value": null},
}
var item_cotainer_database: Dictionary = {}
var workbench_data: Dictionary = {"item_slots": {"InputSlot": {"item_id": null, "item_stack": null}, "OutputSlot": {"item_id": null, "item_stack": null}}}
var burning_furnance_data: Dictionary = {"item_slots": {"InputSlot": {"item_id": null, "item_stack": null}, "CatalystSlot": {"item_id": null, "item_stack": null}, "OutputSlot": {"item_id": null, "item_stack": null}}}
var smelting_furnance_data: Dictionary = {"item_slots": {"InputSlot": {"item_id": null, "item_stack": null}, "CatalystSlot": {"item_id": null, "item_stack": null}, "OutputSlot": {"item_id": null, "item_stack": null}}}
export var static_menu_data: Dictionary = {
	"inventory_data": inventory_data, "equipment_data": equipment_data, "item_container_database": item_cotainer_database,
	"workbench_data": workbench_data, "burning_furnance_data": burning_furnance_data, "smelting_furnance_data": smelting_furnance_data
}
