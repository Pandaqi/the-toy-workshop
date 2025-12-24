extends Node2D
class_name Baskets

var NUM_BASKETS := Global.config.num_baskets
var baskets : Array[Basket]
var score := 0.0
var num_gifts_killed_since_last_delivery := 0
var time_started := 0.0

@export var basket_scene : PackedScene
@export var gifts : Gifts

signal game_over()
signal score_changed(score:float)

func _ready() -> void:
	time_started = Time.get_ticks_msec()
	gifts.gift_killed.connect(_on_gift_killed)
	create_baskets()
	get_viewport().size_changed.connect(_on_size_changed)
	_on_size_changed()

func count() -> void:
	return baskets.size()

func create_baskets() -> void:
	var types : Array[Gift.Type] = []
	var all_types_possible := Gift.get_all_types()
	while types.size() < NUM_BASKETS:
		types += all_types_possible
	types.shuffle()
	
	baskets = []
	for i in range(NUM_BASKETS):
		var b : Basket = basket_scene.instantiate()
		b.set_type(types.pop_back())
		baskets.append(b)
		b.gift_delivered.connect(_on_gift_delivered)
		add_child(b)

func count_gift_delivered_total() -> int:
	var sum := 0
	for b in baskets:
		sum += b.num_delivered
	return sum

func _on_gift_delivered(g:Gift) -> void:
	score_gift(g)
	check_for_game_over()

func _on_size_changed() -> void:
	refresh_baskets()

func refresh_baskets() -> void:
	var vp := get_viewport().get_visible_rect().size
	var basket_width := vp.x / float(NUM_BASKETS)
	for i in range(baskets.size()):
		var b := baskets[i]
		b.set_position(Vector2((i+0.5)*basket_width, vp.y))
		b.set_width(basket_width)

func change_score(ds:float) -> void:
	score = clampf(score + ds, 0.0, 9999.99)
	score_changed.emit(score)

func score_gift(g:Gift) -> void:
	var val := Global.config.score_base
	
	var time_taken := (Time.get_ticks_msec() - g.time_appeared)/1000.0
	var max_time_taken := Global.config.score_bonus_speed_max_duration
	val += lerp(Global.config.score_bonus_speed, 0.0, time_taken/max_time_taken)
	
	var max_gifts_killed := Global.config.score_bonus_fewer_gifts_max
	val += lerp(Global.config.score_bonus_fewer_gifts_destroyed, 0.0, num_gifts_killed_since_last_delivery / float(max_gifts_killed))
	
	var size_base := Global.config.gift_size_base
	var rand := Global.config.gift_size_randomness
	var min_size := size_base - rand
	var max_size := size_base + rand
	var size_multiplier := lerpf(0.75, 1.333, (g.radius - min_size) / (max_size - min_size))
	val *= size_multiplier
	
	change_score(val)
	num_gifts_killed_since_last_delivery = 0

func _on_gift_killed(g:Gift) -> void:
	if g.was_delivered: return
	if not Global.config.lose_points_for_failed_gifts: return
	
	var score_penalty := Global.config.score_penalty_failed
	change_score(score_penalty)
	num_gifts_killed_since_last_delivery += 1

func check_for_game_over() -> void:
	var all_have_enough := true
	for b in baskets:
		if b.has_enough_gifts(): continue
		all_have_enough = false
		break
	
	if not all_have_enough: return
	game_over.emit()
