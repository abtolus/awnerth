extends Control

onready var line_edit = $VBC/LineEdit

func _ready():
	Engine.time_scale = 0

func _physics_process(_delta):
	if Input.is_action_pressed("ui_accept"):
		_on_Button_button_up()

func _on_Button_button_up():
	Engine.time_scale = 1
	if line_edit.text == "":
		return
	PlayerData.personal_data["name"] = line_edit.text
	line_edit.editable = false
	$VBC/Button.disabled = true
	PlayerData.save_data()
	queue_free()
