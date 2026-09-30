extends Door

var player: Node = null

func get_interact() -> void:
	if player:
		queue_free()

func _on_Area2D_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		player = body

func _on_Area2D_body_exited(body: Node) -> void:
	if player == body:
		player = null
