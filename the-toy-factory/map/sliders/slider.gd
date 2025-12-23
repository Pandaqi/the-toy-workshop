extends Node2D
class_name SliderPlayer

var dir := 1
var is_held := false
var fixed := false

var active := false
var player_index := -1

const MOVE_SPEED := 30.0 # @TODO: config
const MOVE_SPEED_MULT_HOLD := 4.5 # @TODO: Config
const Y_BOUND_DIST_FROM_EDGE := 0.2 # @TODO: Config

@export var auto_move_enabled := true
@export var sprite_arrow : Sprite2D

const DEBUG_INPUT_KEYS : Array[String] = ["ui_up", "ui_down", "ui_left", "ui_right"]
var time_pressed := 0.0

func _ready() -> void:
	if randf() <= 0.5: switch_direction() # just to randomize player start situations

func is_active() -> bool:
	return fixed or (active and has_player())

func has_player() -> bool:
	return player_index >= 0

func set_active(val:bool) -> void:
	active = val
	set_visible(active)

func attach_to_player(idx:int) -> void:
	set_active(true)
	player_index = idx

func disconnect_player() -> void:
	set_active(false)
	player_index = -1

func _input(ev:InputEvent) -> void:
	if not is_active(): return
	
	var key := DEBUG_INPUT_KEYS[player_index % DEBUG_INPUT_KEYS.size()]
	if ev.is_action_pressed(key):
		time_pressed = Time.get_ticks_msec()
		is_held = true
	if ev.is_action_released(key):
		var time_held := Time.get_ticks_msec() - time_pressed
		is_held = false
		if time_held < 150.0:
			_on_press()

func _on_press() -> void:
	switch_direction()

func switch_direction() -> void:
	dir *= -1

func _physics_process(delta:float) -> void:
	if not is_active(): return
	auto_move(delta)
	if has_player(): queue_redraw()

func get_speed() -> float:
	var speed := MOVE_SPEED
	if is_held: speed *= MOVE_SPEED_MULT_HOLD
	return speed

func get_path_bounds() -> Dictionary[String,float]:
	var vp := get_viewport().get_visible_rect().size
	return { "min": Y_BOUND_DIST_FROM_EDGE*vp.y, "max": (1.0-Y_BOUND_DIST_FROM_EDGE)*vp.y }

func auto_move(delta:float) -> void:
	if fixed: return
	if not auto_move_enabled: return
	
	sprite_arrow.set_position(Vector2.DOWN * dir * 32)
	sprite_arrow.set_rotation(0.5*PI if dir == 1 else -0.5*PI)
	
	var y_bounds := get_path_bounds()
	var new_pos := get_position() + dir * delta * get_speed() * Vector2.DOWN
	if new_pos.y <= y_bounds.min:
		dir = 1
	if new_pos.y >= y_bounds.max:
		dir = -1
	set_position(new_pos)

func _draw() -> void:
	var b := StyleBoxFlat.new()
	b.bg_color = Color.from_string("#800E10", Color.DARK_RED)
	b.set_corner_radius_all(8)
	var y_bounds := get_path_bounds()
	var thickness := 16.0
	var top_left := Vector2(global_position.x -0.5*thickness, y_bounds.min)
	var rect := Rect2(to_local(top_left), Vector2(thickness, y_bounds.max - y_bounds.min))
	draw_style_box(b, rect)
