class_name PlayerDataTres
extends DataTres

var personal_data: Dictionary = {
	"experience": 0, "cosmetics": {"Head": "head9", "Weapon": "weapon9", "Body": "body2"}
}
var statistics_data: Dictionary = {
	"damage": 7, "fire_rate": 0.75, "damage_reduction": 0, "shield": 0,
	"health": 100, "food_satiation": 100, "water_satisfaction": 100, "speed": 0.0
}
export var static_player_data: Dictionary = {
	"personal_data": personal_data, "statistics_data": statistics_data
}
