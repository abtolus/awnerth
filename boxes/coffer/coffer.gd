extends Box

func get_hit():
	if vulnerability > 1:
		vulnerability -= 1
		return
	
	for _a in range(static_vulnerability):
		drop_item()
	queue_free()
