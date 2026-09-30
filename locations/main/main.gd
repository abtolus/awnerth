extends Node2D
class_name Main

var has_exited: bool = false

export var location_id: String = "main"
export var multiplier_data: Dictionary = {"Easy": 0.75, "Normal": 1, "Hard": 1.25, "Insane": 1.5}

onready var ui: Node = get_node("UI")
onready var ui_elements: Node = get_node("UI/UIElements")
onready var player: Node = $Player
onready var prepare_timer = $Timers/Prepare
onready var save_data_timer = $Timers/SaveData
onready var entities_node = $Entities
onready var entity_spawn_points = $EntitySpawnPoints
onready var in_game_ready_timer = $Timers/InGameReady
onready var directional_light = $DirectionalLight
onready var do_day_and_night_timer = $Timers/DoDayAndNight

func update_day_and_night_cycle(present_cycle_name: String, cycle_value: int = GlobalData.global_data["day_and_night"]["cycle_value"]) -> void:
	match present_cycle_name:
		"Day":
			cycle_value += 1
		"Night":
			cycle_value -= 1
	
	GlobalData.global_data["day_and_night"]["cycle_value"] = cycle_value
	GlobalData.global_data["day_and_night"]["cycle_name"] = present_cycle_name

func do_day_and_night() -> void:
	var cycle_value = GlobalData.global_data["day_and_night"]["cycle_value"]
	var present_cycle_name: String = GlobalData.global_data["day_and_night"]["cycle_name"]
	
	if cycle_value == 16:
		present_cycle_name = "Day"
	elif cycle_value == 85:
		present_cycle_name = "Night"
		
	update_day_and_night_cycle(present_cycle_name)
	directional_light.color = Color8(cycle_value, cycle_value, cycle_value, 255)

func _exit_tree():
	GlobalTscn.stop_theme_audio()

func in_game_ready() -> void:
	if location_id == "home":
		GlobalTscn.play_theme_audio(load("res://audio/theme/work_and_workship.mp3"))
		return
		
	GlobalTscn.play_theme_audio(load("res://audio/theme/%s.mp3" % GlobalTscn.theme_songs[(randi() % GlobalTscn.theme_songs.size())]))

func _ready() -> void:
	location_id = GlobalData.get_split_id(location_id)
	ui.refresh_information_ui()
	var music_value: float = GlobalData.global_data["setting"]["music_value"] * 0.01
	var sfx_value: float = GlobalData.global_data["setting"]["music_value"] * 0.01
	
	do_day_and_night()
	spawn_entities()
	randomize()
	save_data_timer.start()
	player.hunger_timer.start()
	player.thirst_timer.start()
	in_game_ready_timer.start()
	do_day_and_night_timer.start()
	ui_elements.get_node("Minimap").refresh_minimap()
	
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear2db(music_value))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear2db(sfx_value))

func spawn_entities() -> void:
	for i in entity_spawn_points.get_children():
		var random_number = randi() % 100 + 1
		var random_entity_id: String
		for j in GlobalData.static_entity_data.keys():
			if random_number <= GlobalData.static_entity_data[j]["chance"]:
				random_entity_id = j
				break
			else:
				random_number -= GlobalData.static_entity_data[j]["chance"]
		var random_entity_tscn = load("res://characters/%s/%s.tscn" % [random_entity_id, random_entity_id])
		var random_entity = random_entity_tscn.instance()
		for key in random_entity.statistics_data.keys():
			if key in ["damage", "health"]:
				random_entity.statistics_data[key] = random_entity.statistics_data[key] * multiplier_data[GlobalData.global_data["setting"]["difficulty"]]
		random_entity.dropped_item_data["times"] = random_entity.dropped_item_data["times"] * multiplier_data[GlobalData.global_data["setting"]["difficulty"]]
		
		random_entity.global_position = i.position
		entities_node.add_child(random_entity)

func _on_BaseArea_body_entered(body: Node) -> void:
	if !has_exited:
		return
	
	if body.is_in_group("player"):
		var tween = create_tween()
		tween.tween_property(player, "speed", 0, 0.2)
		
		prepare_timer.start()

func _on_BaseArea_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		has_exited = true

func _on_Prepare_timeout() -> void:
	GlobalTscn.change_scene("res://ui/location_menu/location_menu.tscn", "location_menu")

func _on_SaveData_timeout() -> void:
	GlobalData.save_data()
	MenuData.save_data()
	PlayerData.save_data()

func _on_InGameReady_timeout():
	in_game_ready()

func _on_DoDayAndNight_timeout():
	do_day_and_night()

func _on_BossArea_body_entered(body: Node):
	if body.is_in_group("player"):
		for i in get_tree().get_nodes_in_group("boss_door"):
			i.set_collision_layer_bit(2, true)
			i.set_collision_mask_bit(1, true)
			i.set_collision_mask_bit(6, true)
			i.visible = true

func _on_ElevatorArea_body_entered(body: Node):
	if not body.is_in_group("player"):
		return
	get_node("UI/UIElements/ElevatorPopup").show()

func _on_ElevatorArea_body_exited(body: Node):
	if not body.is_in_group("player"):
		return
	get_node("UI/UIElements/ElevatorPopup").hide()
