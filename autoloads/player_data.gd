extends Node

signal RefreshUI

var player_data_tres
var player_node: Node
var default_statistics_data: Dictionary = {
	"damage": 7, "fire_rate": 0.75, "damage_reduction": 0, "shield": 0,
	"health": 100, "food_satiation": 100, "water_satisfaction": 100, "speed": 0.0
}
var personal_data: Dictionary = {
	"experienced": 0, "cosmetics": {"Head": null, "Weapon": null, "Body": null}
}
var statistics_data: Dictionary = {
	"damage": null, "fire_rate": null, "damage_reduction": null, "shield": null,
	"health": null, "food_satiation": null, "water_satisfaction": null, "speed": null
}
var player_data: Dictionary = {
	"personal_data": personal_data, "statistics_data": statistics_data
}
var player_positon: Vector2
var damage_reduction: int
var can_interact: bool = false

var PLAYER_DATA_TRES_PATH: String = "user://player_data_tres"

func _ready():
	load_data()
	emit_signal("RefreshUI")

func increase_value(id: String, increment: int, max_value: int = 100):
	statistics_data[id] += increment
	statistics_data[id] = set_value(statistics_data[id], max_value)
	emit_signal("RefreshUI")
func decrease_value(id: String, decrement: int):
	statistics_data[id] -= decrement
	statistics_data[id] = set_value(statistics_data[id])
	emit_signal("RefreshUI")
func set_value(value, max_value: int = 100) -> float:
	var new_value: float
	if value > max_value:
		new_value = min(value, max_value)
	elif value < 0:
		new_value = 0
	else:
		new_value = abs(value)
	return new_value

func load_data() -> void:
	if PlayerDataTres.data_exists(PLAYER_DATA_TRES_PATH):
		player_data_tres = PlayerDataTres.load_data(PLAYER_DATA_TRES_PATH) as PlayerDataTres
	else:
		player_data_tres = PlayerDataTres.new()
		player_data_tres.save_data(PLAYER_DATA_TRES_PATH)
	
	player_data["statistics_data"].merge(player_data_tres.static_player_data["statistics_data"], true)
	player_data["personal_data"].merge(player_data_tres.static_player_data["personal_data"], true)

func save_data() -> void:
	player_data_tres.static_player_data["statistics_data"] = player_data["statistics_data"]
	player_data_tres.static_player_data["personal_data"] = player_data["personal_data"]
	player_data_tres.save_data(PLAYER_DATA_TRES_PATH)

func get_cyclic_rate(fire_rate: float):
	if fire_rate <= 0.3:
		return 4
	elif fire_rate <= 0.5:
		return 3
	elif fire_rate <= 0.7:
		return 2
	else:
		return 1
