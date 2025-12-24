extends Node2D
class_name Gifts

@export var timer : Timer
@export var gift_scene : PackedScene

@export var sliders : Sliders
var gifts : Array[Gift]

var num_success := 0
var num_failed := 0

signal gift_killed(g:Gift)

func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)
	_on_timer_timeout()

func _on_timer_timeout() -> void:
	var player_count := sliders.get_all_with_player().size()
	var factor := Global.config.num_gifts_on_screen_factor
	var min_gifts := floori(Global.config.min_gifts_on_screen * factor)
	var max_gifts := floori( maxi(Global.config.max_gifts_on_screen_per_player * player_count, Global.config.max_gifts_on_screen_default) * factor )
	
	# ensure we're above minimum
	while count() < min_gifts:
		drop_gift()
	
	# add one extra now if possible
	if count() < max_gifts:
		drop_gift()
	
	# check again in some random amount of time
	timer.wait_time = randf_range(2.0, 5.0)
	timer.start()

func count() -> int:
	return gifts.size()

func drop_gift() -> void:
	var g : Gift = gift_scene.instantiate()
	var random_type : Gift.Type = Gift.get_all_types().pick_random()
	var pos := sliders.get_random_position_within()
	pos.y = 0
	g.set_type(random_type)
	g.set_position(pos)
	g.time_appeared = Time.get_ticks_msec()
	gifts.append(g)
	g.killed.connect(_on_gift_killed)
	add_child(g)

func _on_gift_killed(g:Gift) -> void:
	gifts.erase(g)
	gift_killed.emit(g)
	if not g.was_delivered: num_failed += 1
	else: num_success += 1
