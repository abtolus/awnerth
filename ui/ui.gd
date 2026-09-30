extends CanvasLayer

onready var information_ui = $UIElements/InformationUI
onready var experience_ui = $UIElements/ExperienceUI
onready var player_statistics_ui = $UIElements/PlayerStatisticsUI
onready var player_node = get_node("../Player")
onready var menu_container = $UI2/MenuContainer
onready var control = $UI2/MenuContainer/Control
onready var control_ui = $Joysticks

onready var player_sheet_tscn: PackedScene = preload("res://ui/menu_container/player_sheet/player_sheet.tscn")
onready var inventory_menu_tscn: PackedScene = preload("res://ui/menu_container/inventory_menu/inventory_menu.tscn")
onready var crafting_menu_tscn: PackedScene = preload("res://ui/menu_container/crafting_menu/crafting_menu.tscn")

func _ready():
	PlayerData.connect("RefreshUI", self, "refresh_player_statistics_ui")
	refresh_player_statistics_ui()

func _physics_process(_delta):
	if menu_container.visible == true:
		for i in control_ui.get_children():
			i.joystick_can_be_used = false
	else:
		for i in control_ui.get_children():
			i.joystick_can_be_used = true

func determine_quantity(quantity: int):
	if quantity >= 1000:
		return "%dK" % quantity
	elif quantity >= 1000000:
		return "%dM" % quantity
	elif quantity >= 1000000000:
		return "%dB" % quantity
	else:
		return "%d" % quantity

func refresh_information_ui() -> void:
	var label_node: Node = information_ui.get_node("Label")
	label_node.set_text(GlobalData.location_data[get_node("..").location_id]["name"])
	var difficulty: String = GlobalData.global_data["setting"]["difficulty"]
	var color: Color
	match difficulty:
		"Easy": color = Color("00ff00")
		"Normal": color = Color("ffff00")
		"Hard": color = Color("ffa500")
		"Insane": color = Color("ff0000")
	label_node.set("custom_colors/font_color", color)

func refresh_player_statistics_ui():
	var label_node: Node = experience_ui.get_node("HBC/Label")
	label_node.set_text(determine_quantity(PlayerData.personal_data["experience"]))
	
	var health_node: Node = player_statistics_ui.get_node("VBC/Health")
	var shield_node: Node = player_statistics_ui.get_node("VBC/Shield")
	var food_satiation_node: Node = player_statistics_ui.get_node("VBC/C/HBC/HBC")
	var water_satisfaction_node: Node = player_statistics_ui.get_node("VBC/C/HBC/HBC2")
	
	health_node.value = PlayerData.statistics_data["health"]
	shield_node.value = PlayerData.statistics_data["shield"]
	if MenuData.equipment_data["OffHand"]["item_id"]:
		shield_node.max_value = GlobalData.items[MenuData.equipment_data["OffHand"]["item_id"]]["shield"]
	food_satiation_node.get_node("Statistics").set_text(str(PlayerData.statistics_data["food_satiation"]))
	food_satiation_node.get_node("Statistics").set("custom_colors/font_color", MenuData.get_correct_color(PlayerData.statistics_data["food_satiation"], true))
	water_satisfaction_node.get_node("Statistics").set_text(str(PlayerData.statistics_data["water_satisfaction"]))
	water_satisfaction_node.get_node("Statistics").set("custom_colors/font_color", MenuData.get_correct_color(PlayerData.statistics_data["water_satisfaction"], true))

func _on_Interact_gui_input(event: InputEvent):
	if event is InputEventScreenTouch and not event.pressed:
		player_node.interact()

func _on_OpenInventory_gui_input(event):
	var player_sheet_instance = player_sheet_tscn.instance()
	var inventory_menu_instance = inventory_menu_tscn.instance()
	
	if event is InputEventScreenTouch and not event.pressed:
		control.add_child(player_sheet_instance)
		control.add_child(inventory_menu_instance)
		menu_container.visible = true

func _on_OpenBlueprints_gui_input(event):
	var crafting_menu_instance = crafting_menu_tscn.instance()
	
	if event is InputEventScreenTouch and not event.pressed:
		control.add_child(crafting_menu_instance)
		menu_container.visible = true

func _on_OpenSetting_button_up():
	var setting_tscn: PackedScene = preload("res://autoloads/scenes/setting_tscn.tscn")
	GlobalTscn.add_node(GlobalTscn.get_node("ScreenLayer"), setting_tscn)
