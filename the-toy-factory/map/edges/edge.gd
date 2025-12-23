extends StaticBody2D
class_name Edge

@export var col_shape_node : CollisionShape2D
@export var sprite : Sprite2D
var broken := false

const MIN_ANGLE_FOR_EDGE_BREAK := 0.18*PI # @TODO: Config

func _ready() -> void:
	var col_shape := RectangleShape2D.new()
	col_shape_node.shape = col_shape

func fit_between(a:SliderPlayer, b:SliderPlayer) -> void:
	var vec := b.global_position - a.global_position
	set_rotation(vec.angle())
	
	var center_pos := (a.global_position + b.global_position) * 0.5
	var length := vec.length()
	var width := 32.0 # @TODO: Config
	var size := Vector2(length, width)
	var shp : RectangleShape2D = col_shape_node.shape
	shp.size = size
	
	var base_size := 128.0
	sprite.set_scale(Vector2.ONE * size / base_size)
	
	set_position(center_pos)
	
	# By using angle, we can allow any distance between sliders, 
	# and it will still only break if you're further away from the mean/normal/center line
	var vec_horiz := Vector2(vec.x, 0)
	var angle := vec_horiz.angle_to(vec)
	broken = abs(angle) >= MIN_ANGLE_FOR_EDGE_BREAK
	
	col_shape_node.disabled = broken
	sprite.modulate.a = 0.25 if broken else 1.0
