extends CanvasLayer

func _enter_tree():
	GlobalTscn.play_theme_audio(load("res://audio/theme/virtual_map.mp3"), 0.0)

func _exit_tree():
	GlobalTscn.stop_theme_audio()
