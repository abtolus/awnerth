extends Area2D
class_name Bullet

onready var destruct_timer = $Timers/Destruct

var SPEED: float = 100.0

var damage: int
var bullet_lasting: float
var vector: Vector2 = Vector2.ZERO setget set_target

func _ready():
	destruct_timer.wait_time = bullet_lasting
	destruct_timer.start()

func _physics_process(delta):
	if vector != Vector2.ZERO:
		var velocity = vector * (SPEED * 10) * delta
		global_position += velocity

func set_target(target):
	vector = target

func _on_Bullet_body_entered(body: Node):
	if body.has_method("get_shot"):
		body.get_shot(damage)
	elif body.has_method("get_hit"):
		body.get_hit()
	queue_free()

func _on_Destruct_timeout():
	queue_free()
