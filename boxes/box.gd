class_name Box
extends StaticBody2D

onready var dropped_item_tscn: PackedScene = preload("res://ui/dropped_item.tscn")
onready var dropped_items: Node = get_node("../../DroppedItems")
onready var location: String = get_node("../..").location_id
onready var direction: Vector2 = Vector2.UP.rotated(rotation)

var static_vulnerability: float
var vulnerability: float

func _ready():
	randomize()
	static_vulnerability = rand_range(5, 10)
	vulnerability = static_vulnerability

func get_hit():
	pass

func drop_item():
	var dropped_item = dropped_item_tscn.instance()
	dropped_item.can_move = true
	dropped_item.position = position
	dropped_item.distance = rand_range(64, 128)
	dropped_item.direction = direction
	dropped_item.generate_item(location)
	dropped_items.call_deferred("add_child", dropped_item)
