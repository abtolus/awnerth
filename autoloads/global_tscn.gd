extends Node

onready var theme_audio = $Audio/Theme
var theme_songs: Array = ["anura", "darkwood", "shamura"]
onready var animation_player = $TransitionLayer/AP
onready var await_timer = $TransitionLayer/Await
var packed_scene: PackedScene
onready var location_name_l = $TransitionLayer/Control/LocationNameL
onready var tip_l = $TransitionLayer/Control/TipL
onready var screen_layer = $ScreenLayer
onready var tips: Dictionary = {
	"Tip1": "As soon as you drag the joystick knob without exceeding its outer ring, you can freely aim.",
	"Tip2": "You'll be healed gradually at Home, but if you have a shield, it'll be increased instead.",
	"Tip3": "When you get eliminated in any locations, you lose all of the items in your inventory.",
	"Tip4": "Every weapon, except for your default weapon, has their own durability, so use them wisely.",
	"Tip5": "You could dodge some of the entities' shots by moving and shooting at the same time.",
	"Tip6": "The difficulty affects the gameplay, so choose the one that is best for you in the settings."
}

func _ready():
	stop_theme_audio()

func play_audio(audio: Node, stream: Resource, volume_db: float = 0.0):
	audio.stream = stream
	audio.volume_db = volume_db
	audio.play()
	
func play_theme_audio(stream: Resource, volume_db: float = -20.0):
	theme_audio.stream = stream
	theme_audio.volume_db = volume_db
	theme_audio.play()
func stop_theme_audio():
	theme_audio.stop()
	theme_audio.stream = null

func add_node(parent_node: Node, child_node_tscn: PackedScene) -> void:
	var child_node = child_node_tscn.instance()
	parent_node.call_deferred("add_child", child_node)

func change_scene(target_scene: String, next_scene_id: String) -> void:
	packed_scene = load(target_scene)
	animation_player.play("fade_in")
	await_timer.start()
	
	var random_tip: String = tips[tips.keys()[randi() % tips.keys().size()]]
	tip_l.set_text(random_tip)
	if next_scene_id == "location_menu":
		location_name_l.set_text("The Virtual Map")
		return
	location_name_l.set_text(GlobalData.location_data[next_scene_id]["name"])
func load_scene():
	for i in screen_layer.get_children():
		i.queue_free()
	get_tree().change_scene_to(packed_scene)
func _on_Await_timeout():
	animation_player.play("fade_out")
