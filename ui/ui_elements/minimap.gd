extends MarginContainer

onready var player_node: Node = get_node("../../../Player")
export var zoom = 1

onready var tr: Node = $TR
onready var player_s = $TR/PlayerS
onready var entity_s = $TR/EntityS
onready var object_s = $TR/ObjectS
onready var spawn_s = $TR/SpawnS
onready var elevator_s = $TR/ElevatorS
onready var trs: Dictionary = {"entity": entity_s, "object": object_s, "spawn": spawn_s, "elevator": elevator_s}

var tr_scale
var markers: Dictionary = {}
var minimap_objects: Array = []

func refresh_minimap():
	player_s.position = tr.rect_size / 2
	tr_scale = tr.rect_size / (get_viewport_rect().size * zoom)
	
	minimap_objects = get_tree().get_nodes_in_group("minimap")
	for i in minimap_objects:
		var new_marker = trs[i.minimap_tr].duplicate()
		$TR/Markers.add_child(new_marker)
		new_marker.show()
		markers[i] = new_marker

func mark(i) -> void:
	var object_position = (i.position - player_node.position) * tr_scale + tr.rect_size / 2
	if tr.get_rect().has_point(object_position + tr.rect_position):
		markers[i].show()
	else:
		if !(i.minimap_tr == "spawn"):
			markers[i].hide()
	object_position.x = clamp(object_position.x, 0, tr.rect_size.x)
	object_position.y = clamp(object_position.y, 0, tr.rect_size.y)
	markers[i].position = object_position

func _process(_delta):
	if not player_node:
		return
		
	player_s.rotation = player_node.rotation + PI / 2
	for i in markers:
		mark(i)
