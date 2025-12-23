extends Node2D
class_name Edges

@export var sliders : Sliders

@export var edge_scene : PackedScene
var edges : Array[Edge]

@export var dynamic_edges_enabled := true

func count() -> int:
	return edges.size()

func get_all() -> Array[Edge]:
	return edges.duplicate(false)

func _physics_process(_delta:float) -> void:
	update_edges()

func update_edges() -> void:
	if not dynamic_edges_enabled: return
	
	var slider_nodes := sliders.get_all_active()
	var num_sliders := slider_nodes.size()
	var num_edges_needed := num_sliders - 1
	
	# make sure we have the right amount of slider bodies
	while count() < num_edges_needed:
		add_edge()
	
	while num_edges_needed < count():
		remove_edge()
	
	# then update the object to fit perfectly between sliders
	for i in range(num_edges_needed):
		var slider_a := slider_nodes[i]
		var slider_b := slider_nodes[i+1]
		var edge := edges[i]
		edge.fit_between(slider_a, slider_b)

func add_edge() -> void:
	var e := edge_scene.instantiate()
	edges.append(e)
	add_child(e)

func remove_edge() -> void:
	if edges.size() <= 0: return
	edges.pop_back().queue_free()
