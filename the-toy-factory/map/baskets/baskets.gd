extends Node2D
class_name Baskets

const NUM_BASKETS := 4 # @TODO: Config
var baskets : Array[Basket]

@export var basket_scene : PackedScene

signal game_over()

func _ready() -> void:
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

func _on_gift_delivered(_g:Gift) -> void:
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

func check_for_game_over() -> void:
	var all_have_enough := true
	for b in baskets:
		if b.has_enough_gifts(): continue
		all_have_enough = false
		break
	
	if not all_have_enough: return
	game_over.emit()
