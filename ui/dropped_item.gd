extends Area2D

var is_player: bool = false
var dropped_item_id

var can_move: bool = false
var direction: Vector2
var distance: float

func _ready():
	randomize()
	if can_move:
		move()

func generate_item(location):
	dropped_item_id = GlobalData.get_random_item_id(location)
	var item_icon = load("res://assets/images/items/%s" % GlobalData.items[dropped_item_id]["icon"])
	$TextureRect.texture = item_icon

func move():
	var target_position = position + direction * distance
	var movement = get_tree().create_tween().bind_node(self)
	movement.tween_property(self, "position", target_position, 0.5)

#func _on_DroppedItem_area_entered(area):
#	if area.get_parent().name == "Player":
#		is_player = true
#		$TextureRect.self_modulate = Color("bbbbbb")
#
#func _on_DroppedItem_area_exited(_area):
#	if is_player:
#		is_player = false
#		$TextureRect.self_modulate = Color("ffffff")
