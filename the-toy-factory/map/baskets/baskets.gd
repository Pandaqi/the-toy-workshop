extends Node2D
class_name Baskets

const NUM_BASKETS := 4 # @TODO: Config
var baskets : Array[Basket]
var score := 0.0
var num_gifts_killed_since_last_delivery := 0

@export var basket_scene : PackedScene
@export var gifts : Gifts

signal game_over()
signal score_changed(score:float)

func _ready() -> void:
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
	var val := 10.0 # @TODO: Config base score
	
	var time_taken := (Time.get_ticks_msec() - g.time_appeared)/1000.0
	var max_time_taken := 10.0
	val += lerp(10.0, 0.0, time_taken/max_time_taken) # @TODO: Config these values too
	
	var max_gifts_killed := 5
	val += lerp(10.0, 0.0, num_gifts_killed_since_last_delivery / float(max_gifts_killed))
	
	change_score(val)
	num_gifts_killed_since_last_delivery = 0

func _on_gift_killed(g:Gift) -> void:
	if g.was_delivered: return
	
	var score_penalty := -3
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
