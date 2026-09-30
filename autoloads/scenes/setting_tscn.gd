extends Control

onready var difficulty_ob = $VBC/C/MC/VBC/HBC/DifficultyOB
onready var camera_shake_b = $VBC/C/MC/VBC/HBC2/C/CameraShakeB

onready var music_l = $VBC/C/MC/VBC/HBC3/C/HBC/MusicL
onready var music_hs = $VBC/C/MC/VBC/HBC3/C/HBC/MusicHS
onready var sfx_l = $VBC/C/MC/VBC/HBC4/C/HBC/SfxL
onready var sfx_hs = $VBC/C/MC/VBC/HBC4/C/HBC/SfxHS

onready var MUSIC_BUS_ID = AudioServer.get_bus_index("Music")
onready var SFX_BUS_ID = AudioServer.get_bus_index("SFX")

var options: Dictionary = {
	"difficulty": {"Easy": 0, "Normal": 1, "Hard": 2, "Insane": 3}
}
var difficulty: String
var resolution: Vector2
var is_camera_shake_on: bool
var music_value: int
var sfx_value: int

func refresh_ui() -> void:
	difficulty = GlobalData.global_data["setting"]["difficulty"]
	difficulty_ob.select(options["difficulty"][difficulty])

	is_camera_shake_on = GlobalData.global_data["setting"]["is_camera_shake_on"]
	camera_shake_b.pressed = is_camera_shake_on
	
	music_value = GlobalData.global_data["setting"]["music_value"]
	music_hs.value = music_value
	sfx_value = GlobalData.global_data["setting"]["sfx_value"]
	sfx_hs.value = sfx_value

func _ready():
	refresh_ui()

func _physics_process(_delta):
	music_l.text = str(music_value)
	sfx_l.text = str(sfx_value)

func _on_DifficultyOB_item_selected(index):
	match index:
		0: difficulty = "Easy"
		1: difficulty = "Normal"
		2: difficulty = "Hard"
		3: difficulty = "Insane"
		_: printerr()
	GlobalData.global_data["setting"]["difficulty"] = difficulty

func _on_CameraShakeB_toggled(button_pressed):
	is_camera_shake_on = button_pressed
	if button_pressed:
		camera_shake_b.text = "ON"
	else:
		camera_shake_b.text = "OFF"
	GlobalData.global_data["setting"]["is_camera_shake_on"] = is_camera_shake_on

func _on_MusicHS_value_changed(value):
	music_value = value
	AudioServer.set_bus_volume_db(MUSIC_BUS_ID, linear2db(value / 100))
	GlobalData.global_data["setting"]["music_value"] = music_value

func _on_SfxHS_value_changed(value):
	sfx_value = value
	AudioServer.set_bus_volume_db(SFX_BUS_ID, linear2db(value / 100))
	GlobalData.global_data["setting"]["sfx_value"] = sfx_value

func _on_Exit_button_up():
	queue_free()

func _on_YouTubeB_button_up():
	OS.shell_open("https://www.youtube.com/AKralunig")
