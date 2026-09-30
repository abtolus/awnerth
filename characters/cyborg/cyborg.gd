extends Entity

onready var splash_power_timer = $Timers/SplashPower
onready var cooldown_timer = $Timers/Cooldown

var splash_power_time: float
var splash_power_bullet_lasting: float = 10.0
var is_splash_power_ready: bool = false
var fire_rate: float

func _ready():
	splash_power_timer.start()
	entity_ai.initialize(self)
	fire_rate = statistics_data["fire_rate"]

func do_splash_power() -> void:
	var damage: int = statistics_data["damage"] + 5
	var entity_bullets: Array = []
	var angle: int = 18
	for _i in range(20):
		entity_bullets.append(null)
	
	for i in range(entity_bullets.size()):
		entity_bullets[i] = entity_bullet_tscn.instance()
		entity_bullets[i].modulate = Color8(255, 125, 125)
		entity_bullets[i].SPEED = entity_bullets[i].SPEED / 2
		entity_bullets[i].damage = damage
		entity_bullets[i].bullet_lasting = splash_power_bullet_lasting
		entity_bullets[i].set_target(Vector2.RIGHT.rotated(angle * i))
		entity_bullets[i].global_position = global_position
		projectiles.add_child(entity_bullets[i])
		entity_bullets[i].rotation_degrees = (Vector2.RIGHT.rotated(angle * i).angle() * 180) / PI
		GlobalTscn.play_audio(shot_auido, load("res://audio/sound_effects/shott1.mp3"))
	
	splash_power_timer.start()

func attempt_to_do_splash_power() -> void:
	if splash_power_time > 0:
		do_splash_power()
		splash_power_time -= 1
		return
	is_splash_power_ready = false

func shoot(muzzle_position, muzzle_direction) -> void:
	if is_splash_power_ready:
		self.can_shoot = false
		attempt_to_do_splash_power()
		cooldown_timer.start()
		return

	var damage: int = statistics_data["damage"]
	var bullet_lasting = personal_data["bullet_lasting"]
	self.can_shoot = false
	fire_rate_timer.wait_time = fire_rate
	fire_rate_timer.start()
	
	var entity_bullet = entity_bullet_tscn.instance()
	entity_bullet.SPEED = entity_bullet.SPEED / 1
	entity_bullet.bullet_lasting = bullet_lasting
	projectiles.add_child(entity_bullet)
	entity_bullet.damage = damage
	entity_bullet.global_position = muzzle_position
	entity_bullet.rotation_degrees = (muzzle_direction.angle() * 180) / PI
	bullet_target = muzzle_direction
	entity_bullet.set_target(bullet_target)
	GlobalTscn.play_audio(shot_auido, load("res://audio/sound_effects/shott%d.mp3" % PlayerData.get_cyclic_rate(fire_rate)))

func attempt_to_die() -> void:
	die()
	for i in get_tree().get_nodes_in_group("boss_door"):
		i.queue_free()

func _on_SplashPower_timeout():
	splash_power_time = rand_range(1, 3)
	is_splash_power_ready = true

func _on_Cooldown_timeout():
	can_shoot = true
