extends Control

var virtual_cosmetics: Dictionary = {"Head": null, "Weapon": null, "Body": null}

func _ready():
	refresh()

func refresh() -> void:
	virtual_cosmetics.merge(PlayerData.personal_data["cosmetics"], true)

func _on_Equip_button_up():
	for i in virtual_cosmetics.keys():
		var item_icon = load("res://assets/images/sprites/%s/%s.png" % [i.to_lower(), virtual_cosmetics[i]]) if virtual_cosmetics[i] else null
		PlayerData.player_node.get_node("Sprite/%s" % [i]).set_texture(item_icon)
		PlayerData.personal_data["cosmetics"][i] = virtual_cosmetics[i]
