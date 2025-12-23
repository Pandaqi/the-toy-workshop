extends Node2D
class_name Sliders

@export var slider_scene : PackedScene
var sliders : Array[SliderPlayer]

@export var debug := true

const MAX_PLAYER_COUNT := 12 # @TODO: Config

func _ready() -> void:
	create_sliders()
	debug_slider_players()
	
	get_viewport().size_changed.connect(_on_size_changed)
	_on_size_changed()

func debug_slider_players() -> void:
	if not debug: return
	if not OS.is_debug_build(): return
	
	var test_player_count := 3
	refresh_num_players(test_player_count)

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

func refresh_num_players(n:int) -> void:
	for slider in sliders:
		slider.disconnect_player()
	
	# @TODO: this is a rudimentary way to spread out the players, add more safeguards
	var num_sliders := count()
	for i in range(n):
		var index := floori(i / float(n) * (num_sliders - 2)) + 1
		sliders[index].attach_to_player(i)
		print(i, index)

func create_sliders() -> void:
	# player-controlled sliders
	for i in range(MAX_PLAYER_COUNT):
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
	var x_dist_between_sliders := vp.x / (MAX_PLAYER_COUNT + 1)
	
	sliders.front().set_position(Vector2(0, half_y))
	sliders.back().set_position(Vector2(vp.x, half_y))
	
	for i in range(1, count()-1):
		var new_x := (i+1)*x_dist_between_sliders
		# only override y-pos if not initialized yet; otherwise just keep same
		var new_y := half_y if is_zero_approx(sliders[i].position.y) else sliders[i].position.y
		sliders[i].set_position(Vector2(new_x, new_y))

func get_random_position_within() -> Vector2:
	if sliders.size() <= 2: return Vector2.ZERO
	var left_pos : Vector2 = get_left_most_dynamic().global_position
	var right_pos : Vector2 = get_right_most_dynamic().global_position
	return left_pos.lerp(right_pos, randf())
