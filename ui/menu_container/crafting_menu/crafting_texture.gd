extends ColorRect

onready var crafting_tooltip_tscn: PackedScene = preload("res://ui/menu_container/crafting_menu/crafting_menu_statistics.tscn")

var id

func _on_Icon_gui_input(event):
	if event is InputEventScreenTouch and event.pressed:
		color = Color("444444")
		if get_node("../../../../Control/MC").has_node("CraftingTooltip"):
			get_node("../../../../Control/MC/CraftingTooltip").free()
		else:
			pass
		
		var tooltip_instance = crafting_tooltip_tscn.instance()
		tooltip_instance.item_id = id
		
		get_node("../../../../Control/MC").add_child(tooltip_instance)
	elif event is InputEventScreenTouch and not event.pressed:
		color = Color("333333")
