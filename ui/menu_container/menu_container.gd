extends Control

onready var control = $Control
onready var control_ui = get_node("../../Joysticks")

func _on_Exit_gui_input(event):
	if event is InputEventScreenTouch and not event.pressed:
		visible = !visible
		for child in control.get_children():
			child.queue_free()
		
		# Clear the menmory of the data of the target manufacturer
		for i in MenuData.menu_data["target_manufacturer_data"].keys():
			MenuData.menu_data["target_manufacturer_data"][i] = null
