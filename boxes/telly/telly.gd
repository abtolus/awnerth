extends Box

func get_hit():
	if vulnerability > 1:
		drop_item()
		vulnerability -= 1
		return
	queue_free()
