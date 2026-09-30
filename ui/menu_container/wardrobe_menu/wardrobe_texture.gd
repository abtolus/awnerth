extends ItemTexture

onready var wardrobe_menu_statistics: Node = get_node("../../../../../../Control/MC/WardrobeMenuStatistics")
onready var virtual_node: Node = get_node("../../../../../../Control/MC/WardrobeMenuStatistics/VBC/C/Sprite")

var item_id: String
var item_icon
var item_category: String

func _on_ShopTexture_gui_input(event):
	if event is InputEventScreenTouch and event.pressed:
		color = Color("444444")
		wardrobe_menu_statistics.get_node("VBC/Control/TR").set_texture(item_icon)
		virtual_node.get_node("%s" % item_category).set_texture(item_icon)
		wardrobe_menu_statistics.virtual_cosmetics[item_category] = item_id
	elif event is InputEventScreenTouch and not event.pressed:
		color = Color("333333")
