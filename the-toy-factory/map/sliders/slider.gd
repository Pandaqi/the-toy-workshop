extends Node2D
class_name SliderPlayer

var dir := 1
var is_held := false
var fixed := false
var velocity := 0.0

var active := false
var player_index := -1

var MOVE_SPEED := Global.config.slider_move_speed
var MOVE_SPEED_MULT_HOLD := Global.config.slider_move_speed_mult_hold
var Y_BOUND_DIST_FROM_EDGE := Global.config.slider_y_dist_from_edge
var VELOCITY_CHANGE_SPEED := Global.config.slider_smooth_change_delta

@export var auto_move_enabled := true
@export var sprite : Sprite2D
@export var sprite_arrow : Sprite2D
@export var anim_player : AnimationPlayer
@export var audio_switch : AudioStreamPlayer2D
@export var audio_whir : AudioStreamPlayer2D

const DEBUG_INPUT_KEYS : Array[String] = ["ui_up", "ui_down", "ui_left", "ui_right"]
var time_pressed := 0.0

@export var debug := false

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
	if not (debug and OS.is_debug_build()): return
	
	var key := DEBUG_INPUT_KEYS[player_index % DEBUG_INPUT_KEYS.size()]
	if ev.is_action_pressed(key):
		_on_hold_started()
		
	if ev.is_action_released(key):
		_on_hold_ended()

func _on_hold_started() -> void:
	is_held = true
	anim_player.play("slider_held")

func _on_hold_ended() -> void:
	is_held = false
	anim_player.stop()

func _on_quick_press() -> void:
	switch_direction()

func switch_direction() -> void:
	if audio_switch.playing: return
	Global.tween.play_popup_tween(sprite, 0.1)
	AudioManager.pitch_shift(audio_switch)
	audio_switch.play()
	dir *= -1

func _physics_process(delta:float) -> void:
	if not is_active(): return
	auto_move(delta)
	if has_player(): queue_redraw()

func get_target_speed() -> float:
	var speed := MOVE_SPEED
	if is_held: speed *= MOVE_SPEED_MULT_HOLD
	return speed

func get_path_bounds() -> Dictionary[String,float]:
	var vp := get_viewport().get_visible_rect().size
	return { "min": Y_BOUND_DIST_FROM_EDGE*vp.y, "max": (1.0-Y_BOUND_DIST_FROM_EDGE)*vp.y }

func auto_move(delta:float) -> void:
	if fixed and not Global.config.move_fixed_sliders: return
	if not auto_move_enabled: return
	
	sprite_arrow.set_position(Vector2.DOWN * dir * 32)
	sprite_arrow.set_rotation(0.5*PI if dir == 1 else -0.5*PI)
	
	var speed_target := get_target_speed()
	if Global.config.slider_smooth_change_speed:
		velocity = lerpf(velocity, speed_target, delta * VELOCITY_CHANGE_SPEED)
	else:
		velocity = speed_target
	
	var should_play_audio := absf(velocity) > 0.03 and not audio_whir.playing
	if should_play_audio: audio_whir.play()
	
	var max_speed := MOVE_SPEED * MOVE_SPEED_MULT_HOLD
	audio_whir.volume_db = lerpf(-48, -28, velocity / max_speed)
	
	var y_bounds := get_path_bounds()
	var new_pos := get_position() + dir * delta * velocity * Vector2.DOWN
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
