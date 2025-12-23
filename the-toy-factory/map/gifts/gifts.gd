extends Node2D
class_name Gifts

@export var timer : Timer
@export var gift_scene : PackedScene

@export var sliders : Sliders
var gifts : Array[Gift]

func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)
	_on_timer_timeout()

func _on_timer_timeout() -> void:
	var player_count := sliders.get_all_with_player().size()
	var min_gifts := floori(0.5 * player_count) # @TODO: Config
	var max_gifts := floori(1.5 * player_count)
	
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
	gifts.append(g)
	g.killed.connect(_on_gift_killed)
	add_child(g)

func _on_gift_killed(g:Gift) -> void:
	gifts.erase(g)
