extends Node2D
class_name Sliders

@export var slider_scene : PackedScene
var sliders : Array[SliderPlayer]
var walls : Array[StaticBody2D]

@export var player_data : PlayerData

@export var debug := false
@export var debug_player_count := 6

var NUM_SLIDERS := Global.config.num_sliders

func _ready() -> void:
	create_sliders()
	create_walls()
	debug_slider_players()
	
	get_viewport().size_changed.connect(_on_size_changed)
	_on_size_changed()
	
	Global.input.buttons_changed.connect(_on_buttons_changed)

func create_walls() -> void:
	var dirs := [Vector2.RIGHT, Vector2.LEFT]
	var disable := not Global.config.add_walls
	walls = []
	for i in range(2):
		var wall := StaticBody2D.new()		
		var shape_node := CollisionShape2D.new()
		if disable: shape_node.disabled = true
		
		var shape := WorldBoundaryShape2D.new()
		shape.normal = dirs[i]
		shape_node.shape = shape
		
		wall.add_child(shape_node)
		add_child(wall)
		walls.append(wall)

func debug_slider_players() -> void:
	if not debug: return
	if not OS.is_debug_build(): return
	
	refresh_players()

func count() -> int:
	return sliders.size()

func get_all() -> Array[SliderPlayer]:
	return sliders.duplicate(false)

func get_all_active() -> Array[SliderPlayer]:
	return sliders.filter(func(s): return s.is_active())

func get_all_with_player() -> Array[SliderPlayer]:
	return sliders.filter(func(s:SliderPlayer): return s.player_index >= 0)

func get_left_most_dynamic() -> SliderPlayer:
	return sliders[1]

func get_right_most_dynamic() -> SliderPlayer:
	return sliders[sliders.size() - 2]

func _on_buttons_changed() -> void:
	refresh_players()

func refresh_players() -> void:
	for slider in sliders:
		slider.disconnect_player()
	
	var num_players := player_data.count()
	if debug and OS.is_debug_build(): num_players = debug_player_count
	if num_players <= 0: return
	
	# @TODO: this is a rudimentary way to spread out the players, 
	# add more safeguards or just manually input all the configurations?
	var num_sliders := count()
	for i in range(num_players):
		var index_raw := floori((i+0.5) / float(num_players) * num_sliders - 1)
		var index := clampi(index_raw, 1, count() - 2)
		sliders[index].attach_to_player(i)
		player_data.players[i].attach_slider(sliders[index])
		print(i, index)

func create_sliders() -> void:
	# player-controlled sliders
	for i in range(NUM_SLIDERS):
		var s := create_slider()
		sliders.push_back(s)
	
	# fixed sliders
	var slider_start := create_slider()
	slider_start.fixed = true
	sliders.push_front(slider_start)
	
	var slider_end := create_slider()
	slider_end.fixed = true
	sliders.push_back(slider_end)

func create_slider(pos := Vector2.ZERO) -> SliderPlayer:
	var s : SliderPlayer = slider_scene.instantiate()
	s.set_position(pos)
	add_child(s)
	return s

func _on_size_changed() -> void:
	refresh_slider_positions()

func refresh_slider_positions() -> void:
	var vp := get_viewport().get_visible_rect().size
	var half_y := 0.5*vp.y
	var x_dist_between_sliders := vp.x / (NUM_SLIDERS + 1)
	
	sliders.front().set_position(Vector2(0, half_y))
	sliders.back().set_position(Vector2(vp.x, half_y))
	
	for i in range(1, count()-1):
		var new_x := (i+1)*x_dist_between_sliders
		# only override y-pos if not initialized yet; otherwise just keep same
		var new_y := half_y if is_zero_approx(sliders[i].position.y) else sliders[i].position.y
		sliders[i].set_position(Vector2(new_x, new_y))
	
	# walls too
	walls[0].set_position(Vector2(0, half_y))
	walls[1].set_position(Vector2(vp.x, half_y))

func get_random_position_within() -> Vector2:
	if sliders.size() <= 2: return Vector2.ZERO
	var left_pos : Vector2 = get_left_most_dynamic().global_position
	var right_pos : Vector2 = get_right_most_dynamic().global_position
	return left_pos.lerp(right_pos, randf())
