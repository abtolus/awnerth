extends TextureButton

export (String) var location_id

onready var level_tooltip_tscn: PackedScene = preload("res://ui/location_menu/location_menu_statistics.tscn")
onready var vbc2: Node = get_node("../../../../../../VBC2")

func _on_TB_gui_input(event: InputEvent):
	if event is InputEventScreenTouch and event.pressed:
		self_modulate = Color("000000")
		if vbc2.has_node("LocationMenuStatistics"):
			vbc2.get_node("LocationMenuStatistics").free()

		var level_tooltip = level_tooltip_tscn.instance()
		vbc2.add_child(level_tooltip)
		
		level_tooltip.location_id = location_id
		level_tooltip.inform()
		
		vbc2.get_node("LocationMenuStatistics/MC/VBC/Travel").show();
	elif event is InputEventScreenTouch and not event.pressed:
		self_modulate = Color("ffffff")
