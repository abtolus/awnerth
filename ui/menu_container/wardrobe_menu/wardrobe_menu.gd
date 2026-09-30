extends Control

export (PackedScene) var ItemTexture

onready var wardrobe_menu_statistics: Node = get_node("HBC/Control/MC/WardrobeMenuStatistics")
onready var virtual_node: Node = get_node("HBC/Control/MC/WardrobeMenuStatistics/VBC/C/Sprite")
onready var tc = $HBC/VBC/TC

# Display the number of columns and rows of the item slots in the inventory UI.
func _ready():
	for i in GlobalData.cosmetics.keys():
		var item_texture = ItemTexture.instance()
		item_texture.rect_min_size = Vector2(128, 128)
		var item_id = i
		var item_category: String = GlobalData.cosmetics[i]["category"].to_lower()
		var item_icon = load("res://assets/images/sprites/%s/%s.png" % [item_category.to_lower(), i])
		item_texture.get_node("Icon").set_texture(item_icon)
		item_texture.item_id = item_id
		item_texture.item_icon = item_icon
		item_texture.item_category = GlobalData.cosmetics[i]["category"]
		tc.get_node("%s/SC/GC" % GlobalData.cosmetics[i]["category"]).add_child(item_texture, true)
	for i in PlayerData.personal_data["cosmetics"].keys():
		var k = PlayerData.personal_data["cosmetics"]
		var item_icon = load("res://assets/images/sprites/%s/%s.png" % [i.to_lower(), k[i]]) if k[i] else null
		virtual_node.get_node("%s" % i).set_texture(item_icon)
