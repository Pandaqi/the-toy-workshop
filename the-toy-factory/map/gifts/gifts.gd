extends Node2D
class_name Gifts

@export var timer : Timer
@export var gift_scene : PackedScene

@export var sliders : Sliders

func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)
	_on_timer_timeout()

func _on_timer_timeout() -> void:
	release_gift()
	timer.wait_time = randf_range(0.5, 2.0)
	timer.start()

func release_gift() -> void:
	var g : Gift = gift_scene.instantiate()
	var pos := sliders.get_random_position_within()
	pos.y = 0
	g.set_position(pos)
	add_child(g)
