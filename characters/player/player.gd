extends KinematicBody2D
class_name Player

var detected_items: Dictionary

onready var sprite = $Sprite
onready var camera: Node = $Camera
onready var projectiles = $"../Projectiles"
onready var bullet_indicator = $BulletIndicator
onready var fire_rate_timer = $Timers/FireRate
onready var weapon = $Sprite/Weapon
onready var muzzle = $Muzzle
onready var hunger_timer = $Timers/Hunger
onready var thirst_timer = $Timers/Thirst
onready var heal_timer = $Timers/Heal
onready var shot_audio = $Audio/Shot
var player_bullet_tscn: PackedScene = preload("res://projectiles/player_bullet/player_bullet.tscn")
var target: Vector2
onready var joystick_one_path: NodePath = "../UI/Joysticks/Joystick";
onready var joystick_two_path: NodePath = "../UI/Joysticks/Joystick2";
var joystick_one;
var joystick_two;
var speed: float = 150.0;
const JOYSTICK_DEADZONE = 0.9;
var bullet_is_reloaded: bool = true
var is_alive: bool = true
var interacting_object: Node
var location_id: String

func _ready():
	location_id = get_parent().location_id
	if location_id == "home" and is_alive:
		heal_timer.start()
	joystick_one = get_node(joystick_one_path);
	joystick_two = get_node(joystick_two_path);
	# Use the updated signal to update the rotation when the joystick changes
	joystick_two.connect("Joystick_Updated", self, "rotation_updated");
	
	PlayerData.player_node = self
	for i in sprite.get_children():
		var item_icon = load("res://assets/images/sprites/%s/%s.png" % [i.name.to_lower(), PlayerData.personal_data["cosmetics"][i.name]])
		i.set_texture(item_icon)

func _process(_delta):
	if is_alive and PlayerData.statistics_data["health"] == 0:
		is_alive = false
		die()
	PlayerData.player_positon = global_position
	if (joystick_two.joystick_vector.length() >= JOYSTICK_DEADZONE):
		attempt_to_shoot()

func _physics_process(delta):
	if speed > 0:
		speed = 150 - (-150 * (PlayerData.statistics_data["speed"] / 100))
	# Move based on the joystick, only if the joystick is farther than the dead zone.
	if (joystick_one.joystick_vector.length() >= JOYSTICK_DEADZONE):
		move_and_collide(-joystick_one.joystick_vector * speed * delta, true);
		PlayerData.player_positon = global_position

func rotation_updated():
	# Convert the joystick vector to rotation using angle_to_point, only if the joystick is farther
	# than the dead zone.
	if (joystick_two.joystick_vector.length() > JOYSTICK_DEADZONE/10):
		rotation = global_position.angle_to_point(global_position + joystick_two.joystick_vector);
		target = -joystick_two.joystick_vector

func shoot(damage: int = 7, fire_rate: float = 0.75, bullet_lasting: float = 0.225):
	var overall_rotation = ((-joystick_two.joystick_vector).angle() * 180)/PI
	bullet_is_reloaded = false
	fire_rate_timer.wait_time = fire_rate
	fire_rate_timer.start()
	
	var player_bullet = player_bullet_tscn.instance()
	player_bullet.bullet_lasting = bullet_lasting
	projectiles.add_child(player_bullet)
	player_bullet.global_position = muzzle.global_position
	player_bullet.rotation_degrees = overall_rotation
	player_bullet.damage = damage
	player_bullet.set_target(target)
	GlobalTscn.play_audio(shot_audio, load("res://audio/sound_effects/shott%d.mp3" % PlayerData.get_cyclic_rate(fire_rate)))

func attempt_to_shoot():
	var damage: int = PlayerData.statistics_data["damage"]
	var fire_rate: float = PlayerData.statistics_data["fire_rate"]
	if MenuData.equipment_data["MainHand"]["item_id"] and MenuData.equipment_data["MainHand"]["item_value"] > 0:
		var bullet_lasting = GlobalData.items[MenuData.equipment_data["MainHand"]["item_id"]]["bullet_lasting"]
		if bullet_is_reloaded:
			MenuData.decrease_equipped_items(["MainHand"])
			bullet_indicator.value = MenuData.equipment_data["MainHand"]["item_value"]
			shoot(damage, fire_rate, bullet_lasting)
			if GlobalData.global_data["setting"]["is_camera_shake_on"]:
				camera.apply_shake()
	else:
		if bullet_is_reloaded:
			shoot()
			if GlobalData.global_data["setting"]["is_camera_shake_on"]:
				camera.apply_shake()

func interact():
	if interacting_object:
		if interacting_object.has_method("get_interact"):
			interacting_object.get_interact()
	else:
		if MenuData.is_inventory_full():
			return
		pick_up_item()

func pick_up_item():
	if detected_items.size() > 0:
		var last_index = detected_items.values().size() - 1
		var picked_item_node = detected_items.keys()[last_index]
		var picked_item_id = detected_items.values()[last_index]
		for key in MenuData.inventory_data.keys():
			if MenuData.inventory_data[key]["item_id"] == null:
				MenuData.inventory_data[key]["item_id"] = str(picked_item_id)
				MenuData.inventory_data[key]["item_stack"] = 1
				detected_items.erase(picked_item_node)
				break
			elif MenuData.inventory_data[key]["item_id"] and MenuData.inventory_data[key]["item_id"] == picked_item_id:
				if MenuData.inventory_data[key]["item_stack"] < MenuData.MAX_STACK:
					MenuData.inventory_data[key]["item_stack"] += 1
					detected_items.erase(picked_item_node)
					break
				else:
					pass
			else:
				pass
		get_node("../DroppedItems").remove_child(picked_item_node)

func _on_Reload_timeout():
	bullet_is_reloaded = true

func get_shot(damage: int):
	var shield = PlayerData.statistics_data["shield"]
	var damage_reduction = PlayerData.statistics_data["damage_reduction"]
	if shield > 0:
		MenuData.decrease_equipped_items(["OffHand"])
		PlayerData.decrease_value("shield", damage)
		PlayerData.emit_signal("RefreshUI")
		return
	MenuData.decrease_equipped_items(["Head", "Chest", "Feet"])
	if damage_reduction > 0:
		damage = damage - (damage * (damage_reduction / (damage_reduction + 39.667)))
	if damage >= 0:
		PlayerData.decrease_value("health", damage)
	else:
		PlayerData.decrease_value("health", 0)
	PlayerData.emit_signal("RefreshUI")

func die():
	var dealth_tscn: PackedScene = load("res://autoloads/scenes/dealth_tscn.tscn")
	GlobalTscn.add_node(GlobalTscn.get_node("ScreenLayer"), dealth_tscn)
	
	get_node("../UI").queue_free()
	
	queue_free()

func _on_InteractArea_area_entered(area: Area2D):
	if area.is_in_group("dropped_item"):
		detected_items[area] = area.dropped_item_id
		return

func _on_InteractArea_area_exited(area: Area2D):
	if detected_items.has(area):
		detected_items.erase(area)

func _on_Hunger_timeout():
	var statistics_id: String = "food_satiation"
	if PlayerData.statistics_data[statistics_id] == 0:
		PlayerData.decrease_value("health", 2)
		return
	PlayerData.decrease_value(statistics_id, 1)

func _on_Thirst_timeout():
	var statistics_id: String = "water_satisfaction"
	if PlayerData.statistics_data[statistics_id] == 0:
		PlayerData.decrease_value("health", 1)
		return
	PlayerData.decrease_value(statistics_id, 1)

func _on_InteractArea_body_entered(body):
	if body.is_in_group("interaction"):
		interacting_object = body
		return

func _on_InteractArea_body_exited(_body):
	interacting_object = null

func _on_Heal_timeout():
	if PlayerData.statistics_data["food_satiation"] == 0 or PlayerData.statistics_data["water_satisfaction"] == 0:
		return
	PlayerData.increase_value("health", 1)
	if MenuData.equipment_data["OffHand"]["item_id"]:
		PlayerData.increase_value("shield", 1, GlobalData.items[MenuData.equipment_data["OffHand"]["item_id"]]["shield"])
