extends Furniture

onready var menu_container = get_node("../../UI/UI2/MenuContainer")
onready var wardrobe_menu_tscn: PackedScene = preload("res://ui/menu_container/wardrobe_menu/wardrobe_menu.tscn")

func get_interact() -> void:
	var wardrobe_menu = wardrobe_menu_tscn.instance()
	var control = menu_container.get_node("Control")
	menu_container.visible = true
	
	control.add_child(wardrobe_menu)
