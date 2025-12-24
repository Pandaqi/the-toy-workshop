extends RigidBody2D
class_name Gift

enum Type
{
	SQUARE,
	STAR,
	CIRCLE,
	TRIANGLE
}

const COLORS = [Color(1.0,0.8, 0.8), Color(1.0, 1.0, 0.8), Color(0.8, 0.8, 1.0), Color(0.8, 1.0, 0.8)]

@export var sprite : Sprite2D
@export var col_shape_node : CollisionShape2D
var type : Type
var time_appeared := 0.0
var was_delivered := false
var already_killed := false
var radius := 16.0

@export var audio_appear : AudioStreamPlayer2D
@export var audio_deliver : AudioStreamPlayer2D
@export var audio_killed : AudioStreamPlayer2D
@export var audio_hit : AudioStreamPlayer2D

signal killed(g:Gift)

static func get_all_types() -> Array[Type]:
	var arr : Array[Type] = []
	arr.assign(Type.values())
	return arr

static func get_frame_for_type(tp:Type) -> int:
	return Type.values().find(tp)

static func get_color_for_type(tp:Type) -> Color:
	return COLORS[Gift.get_frame_for_type(tp)]

func _ready() -> void:
	AudioManager.pitch_shift(audio_appear)
	audio_appear.play()
	body_entered.connect(_on_body_entered)
	Global.tween.play_popup_tween(sprite)
	refresh_size()

func _physics_process(_delta:float) -> void:
	check_if_off_screen()

func check_if_off_screen() -> void:
	var pos := global_position
	var vp := get_viewport().get_visible_rect().size
	if pos.y <= vp.y: return
	kill()

func set_type(tp:Type) -> void:
	type = tp
	sprite.set_frame(Gift.get_frame_for_type(tp))

func is_type(tp:Type) -> bool:
	return type == tp

func refresh_size() -> void:
	var rand := Global.config.gift_size_randomness
	var base := Global.config.gift_size_base
	
	radius = randf_range(-1,1) * rand + base
	if not Global.config.allow_different_gift_sizes: 
		radius = base
	
	var shape := CircleShape2D.new()
	shape.radius = radius
	col_shape_node.shape = shape
	
	sprite.set_scale(Vector2.ONE * radius * 2 / 256.0)

func kill(good := false) -> void:
	if already_killed: return
	
	was_delivered = good
	already_killed = true
	
	if good: 
		AudioManager.pitch_shift(audio_deliver)
		audio_deliver.play()
	else: 
		AudioManager.pitch_shift(audio_killed)
		audio_killed.play()
	
	col_shape_node.set_deferred("disabled", true)
	
	var tw := Global.tween.play_popup_tween(sprite)
	await tw.finished
	
	var tw2 := Global.tween.play_fadeout_tween(sprite, 1.0)
	await tw2.finished
	
	queue_free()
	killed.emit(self)

func _on_body_entered(_body:Node) -> void:
	if audio_hit.playing: return
	AudioManager.pitch_shift(audio_hit)
	audio_hit.play()
