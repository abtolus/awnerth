extends EntityAI

onready var reload_timer = $"../Timers/Reload"
onready var bullets: float = 0
var is_reloading: bool = false

func have_bullets() -> bool:
	if bullets > 0:
		bullets -= 1
		return true
	else:
		if not is_reloading:
			reload_timer.start()
			is_reloading = true
			return false
	return false

func attempt_to_shoot(angle_to_player) -> void:
	var muzzle_position: Vector2 = $"../Muzzle".global_position
	var muzzle_direction: Vector2 = (PlayerData.player_positon - self_entity.global_position).normalized()
	
	if abs(self_entity.rotation - angle_to_player) < 0.1:
		if self_entity.can_shoot and have_bullets():
			self_entity.shoot(muzzle_position, muzzle_direction)
			return
		elif self_entity.can_shoot and self_entity.is_splash_power_ready:
			for _i in range(2):
				self_entity.shoot(muzzle_position, muzzle_direction)

func _on_Reload_timeout():
	bullets = rand_range(5, 11)
	is_reloading = false
