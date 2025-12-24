extends StaticBody2D
class_name Edge

@export var col_shape_node : CollisionShape2D
var broken := false
var rect : Rect2
var y_dist := 0.0

@export var audio_snap : AudioStreamPlayer2D
@export var audio_stretch : AudioStreamPlayer2D

var THICKNESS := Global.config.edge_thickness
var MIN_DIST_FOR_EDGE_BREAK := Global.config.edge_dist_break

func _ready() -> void:
	var col_shape := RectangleShape2D.new()
	col_shape_node.shape = col_shape

func fit_between(a:SliderPlayer, b:SliderPlayer) -> void:
	var vec := b.global_position - a.global_position
	set_rotation(vec.angle())
	
	var center_pos := (a.global_position + b.global_position) * 0.5
	var length := vec.length()
	var width := THICKNESS
	var size := Vector2(length, width)
	var shp : RectangleShape2D = col_shape_node.shape
	shp.size = size
	
	rect = Rect2(-0.5*size, size)
	
	# for when I used a SPRITE for this instead of custom _draw()
	#var base_size := 256.0
	#var sprite_scale := Vector2.ONE * size / base_size
	#sprite.set_scale(sprite_scale)
	#sprite.material.set_shader_parameter("scale", sprite_scale)
	
	set_position(center_pos)
	
	y_dist = absf(vec.y)
	var was_broken := broken
	broken = y_dist >= get_dist_for_break()
	if not was_broken and broken:
		AudioManager.pitch_shift(audio_snap)
		audio_snap.play()
	
	col_shape_node.disabled = broken
	modulate.a = 0.25 if broken else 1.0
	
	queue_redraw()

func get_dist_for_break() -> float:
	return MIN_DIST_FOR_EDGE_BREAK * get_viewport().get_visible_rect().size.y

func _draw() -> void:
	var b := StyleBoxFlat.new()
	b.bg_color = Color.BLACK
	
	var dist_break := get_dist_for_break()
	var about_to_break := y_dist >= dist_break*0.8 and y_dist <= dist_break
	var about_to_unbreak := y_dist >= dist_break and y_dist <= dist_break * 1.25
	if about_to_break or about_to_unbreak:
		b.bg_color = Color.DARK_RED
	
	if about_to_break and not audio_stretch.playing: 
		AudioManager.pitch_shift(audio_stretch)
		audio_stretch.play()
	
	b.border_color = Color.WHITE
	b.set_corner_radius_all(8)
	b.set_border_width_all(2)
	draw_style_box(b, rect)
