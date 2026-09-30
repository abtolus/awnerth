class_name GlobalDataTres
extends DataTres

var setting: Dictionary = {
	"difficulty": "Normal", "resolution": Vector2(1920, 1080),
	"is_camera_shake_on": false, "music_value": 100, "sfx_value": 100
}
var day_and_night: Dictionary = {
	"cycle_name": "Day", "cycle_value": 51
}
export var static_global_data:Dictionary = {
	"setting": setting, "day_and_night": day_and_night
}
