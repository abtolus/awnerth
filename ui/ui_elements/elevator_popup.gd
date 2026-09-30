extends Popup

onready var option_button = $MC/OptionButton

var floor_data: Dictionary

func _ready():
	if not "floor_id" in get_node("../../.."):
		return
	floor_data = get_node("../../..").floor_data
	option_button.select(GlobalData.get_by_param(floor_data, ["id", get_node("../../..").floor_id, "index"]))

func _on_OptionButton_item_selected(index):
	var location_id: String = get_node("../../..").location_id
	var floor_id: String = GlobalData.get_by_param(floor_data, ["index", index, "id"])
	
	GlobalTscn.change_scene("res://locations/%s/%s.tscn" % [location_id, floor_id], location_id)
	hide()
