extends KinematicBody2D
class_name Entity

export var dropped_item_data: Dictionary = {"times": null}
export var statistics_data: Dictionary = {
	"damage": null, "fire_rate": null, "health": null, "speed": null}
export var personal_data: Dictionary = {"name": null, "experience": null, "bullet_lasting": null}

onready var sprites = $Sprites
onready var direction: Vector2 = Vector2.RIGHT.rotated(rotation)
onready var entity_bullet_tscn: PackedScene = preload("res://projectiles/entity_bullet/entity_bullet.tscn")
onready var dropped_item_tscn: PackedScene = preload("res://ui/dropped_item.tscn")
onready var location: String = get_node("../..").location_id
onready var dropped_items = get_node("../../DroppedItems")
onready var projectiles = get_node("../../Projectiles")
onready var fire_rate_timer = $Timers/FireRate
onready var get_shot_timer = $Timers/GetShot

onready var entity_ai = $EntityAI
onready var shot_auido = $Audio/Shot

var minimap_tr: String = "entity"
var can_shoot: bool = true
var bullet_target: Vector2

func _ready():
	entity_ai.initialize(self)

func shoot(muzzle_postion, muzzle_direction):
	var damage: int = statistics_data["damage"]
	var fire_rate: float = statistics_data["fire_rate"]
	var bullet_lasting = personal_data["bullet_lasting"]
	self.can_shoot = false
	fire_rate_timer.wait_time = fire_rate
	fire_rate_timer.start()
	
	var entity_bullet = entity_bullet_tscn.instance()
	entity_bullet.bullet_lasting = bullet_lasting
	projectiles.add_child(entity_bullet)
	entity_bullet.damage = damage
	entity_bullet.global_position = muzzle_postion
	entity_bullet.rotation_degrees = (muzzle_direction.angle() * 180) / PI
	bullet_target = muzzle_direction
	entity_bullet.set_target(bullet_target)
	GlobalTscn.play_audio(shot_auido, load("res://audio/sound_effects/shott%d.mp3" % PlayerData.get_cyclic_rate(fire_rate)))

func get_shot(damage: int):
	statistics_data["health"] -= damage
	sprites.modulate = Color("222222")
	get_shot_timer.start()
	if statistics_data["health"] <= 0:
		attempt_to_die()

func attempt_to_die() -> void:
	die()

func die():
	PlayerData.personal_data["experience"] += personal_data["experience"]
	PlayerData.emit_signal("RefreshUI")
	PlayerData.emit_signal("RefreshUI")
	for _i in range(dropped_item_data["times"]):
		drop_item()
	get_node("../../UI/UIElements/Minimap").markers[self].queue_free()
	get_node("../../UI/UIElements/Minimap").markers.erase(self)
	queue_free()

func drop_item():
	var dropped_item = dropped_item_tscn.instance()
	dropped_item.can_move = true
	dropped_item.position = position
	dropped_item.distance = rand_range(0, 16)
	dropped_item.direction = -direction
	dropped_item.generate_item(location)
	dropped_items.call_deferred("add_child", dropped_item)

func _on_GetShot_timeout():
	sprites.modulate = Color("ffffff")
