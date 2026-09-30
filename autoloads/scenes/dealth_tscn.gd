extends Control

func _ready():
	GlobalTscn.stop_theme_audio()

func _on_Respawn_button_up():
	GlobalData.on_Respawn_pressed()
	GlobalTscn.change_scene("res://locations/home/home.tscn", "home")
	$VBC/GetBackUpAgain.text = "Loading..."
	$VBC/GetBackUpAgain.disabled = true
