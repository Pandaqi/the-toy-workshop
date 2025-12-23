extends Node2D
class_name Baskets

const NUM_BASKETS := 4

@export var basket_scene : PackedScene

func _ready() -> void:
	create_baskets()

func create_baskets() -> void:
	# @TODO: actually use a fixed map size and ensure everything fits together; maybe depend on sliders?
	var vp := get_viewport().get_visible_rect().size
	var basket_width := vp.x / float(NUM_BASKETS)
	for i in range(NUM_BASKETS):
		var b : Basket = basket_scene.instantiate()
		b.set_position(Vector2((i+0.5)*basket_width, vp.y))
		b.set_width(basket_width)
		add_child(b)
