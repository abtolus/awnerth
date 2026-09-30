extends Node2D
class_name EntityAI

signal StateChanged(new_state)

enum State {
	INACTIVE,
	ACTIVE
}

export var entity_ai_data: Dictionary = {
	"patrol_state": {"speed": null, "distance": null, "rotation_speed": null}
}

onready var sensor = $Sensor
onready var patrol_timer = $"../Timers/Patrol"
onready var vision = $"../Vision"

var speed: float
var current_state: int = -1 setget set_state

var player: Player = null
var self_entity: Entity = null
var self_entity_velocity: Vector2 = Vector2.ZERO

var hit_position

# Inactive State
var origin: Vector2 = Vector2.ZERO
var patrol_location: Vector2 = Vector2.ZERO
var patrol_location_reached: bool = false

var is_player_detected: bool = false
onready var is_player_nearby: bool = false

func _ready():
	set_state(State.INACTIVE)

func iretate_through_vision() -> void:
	for i in vision.get_children():
		# Check if the entity sees the player
		if i.get_collider() != null and i.get_collider().name == "Player":
			if is_player_nearby == false:
				speed = self_entity.statistics_data["speed"]
			else:
				speed = 0
			player = i.get_collider()
			set_state(State.ACTIVE)
			return
		else:
			# Check if the player is near the entity
			if is_player_detected == true and get_detected_object(PlayerData.player_positon) == "Player":
				speed = self_entity.statistics_data["speed"]
				set_state(State.ACTIVE)
				return
			else:
				set_state(State.INACTIVE)

func _physics_process(_delta):
	iretate_through_vision()
	match current_state:
		State.INACTIVE:
			speed = entity_ai_data["patrol_state"]["speed"]
			patrol()
		State.ACTIVE:
			if player != null:
				# The entity moves towards the player
				var direction = (PlayerData.player_positon - self_entity.position).normalized()
				var velocity = direction * speed
				self_entity.move_and_slide(velocity)
				
				# The entity looks at the player
				var angle_to_player = self_entity.global_position.direction_to(PlayerData.player_positon).angle()
				self_entity.rotation = lerp_angle(self_entity.rotation, angle_to_player, 0.25)
				
				# The entity shoots the player
				if not is_player_nearby:
					return
				attempt_to_shoot(angle_to_player)
		_:
			printerr("Found a state for an entity that doesn't exist.")

func patrol():
	if not patrol_location_reached:
		self_entity.move_and_slide(self_entity_velocity)
		var angle_to_patrol_location = self_entity.global_position.direction_to(patrol_location).angle()
		self_entity.rotation = lerp(self_entity.rotation, angle_to_patrol_location, entity_ai_data["patrol_state"]["rotation_speed"])
		
		if self_entity.global_position.distance_to(patrol_location) < 10 or self_entity.is_on_wall():
			patrol_timer.start()
			patrol_location_reached = true

# Attempt to shoot the bullet
func attempt_to_shoot(angle_to_player):
	var muzzle_position: Vector2 = get_node("../Muzzle").global_position
	var muzzle_direction: Vector2 = (PlayerData.player_positon - self_entity.position).normalized()
	
	if abs(self_entity.rotation - angle_to_player) < 0.1 and self_entity.can_shoot:
		self_entity.shoot(muzzle_position, muzzle_direction)

# Initialize using the Entity class
func initialize(entity: Entity):
	self.self_entity = entity

# Set the state for the entity
func set_state(new_state: int):
	if new_state == current_state:
		return
	
	if new_state == State.INACTIVE:
		origin = global_position
		patrol_timer.start()
		patrol_location_reached = true
	
	current_state = new_state
	emit_signal("StateChanged", current_state)

# Check if the entity can see the desired position
func get_detected_object(desired_position) -> String:
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(self_entity.global_position,
	desired_position,
	[self_entity], self_entity.collision_mask, true)

	if result:
		hit_position = result.position
		if result.collider.is_in_group("player"):
			return "Player"
		else:
			return "false"
	else:
		return "There is no result."

func _on_FireRate_timeout():
	self_entity.can_shoot = true

func _on_Patrol_timeout():
	var distance = entity_ai_data["patrol_state"]["distance"]
	var random_x = rand_range(-distance, distance)
	var random_y = rand_range(-distance, distance)
	
	patrol_location = Vector2(random_x, random_y) + origin
	
	patrol_location_reached = false
	speed = entity_ai_data["patrol_state"]["speed"]
	self_entity_velocity = self_entity.global_position.direction_to(patrol_location) * speed

func _on_Sensor_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		is_player_detected = true
		player = body

func _on_Sensor_body_exited(body: Node) -> void:
	if player and body == player:
		is_player_detected = false
		player = null

func _on_Nearby_body_entered(body: Node):
	if body.is_in_group("player"):
		is_player_nearby = true

func _on_Nearby_body_exited(body: Node):
	if player and body == player:
		is_player_nearby = false
