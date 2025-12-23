extends Node2D
class_name Basket

@export var area : Area2D
@export var col_shape_node : CollisionShape2D
@export var sprite : Sprite2D
@export var sprite_type : Sprite2D

const BASKET_HEIGHT := 96.0 # @TODO: Config??
const GIFT_DELIVERED_TARGET := 5 # @TODO: Config

var num_delivered := 0
var type : Gift.Type

signal gift_delivered(g:Gift)

func _ready() -> void:
	area.body_entered.connect(_on_body_entered)

func set_type(tp:Gift.Type) -> void:
	type = tp
	sprite_type.set_frame(Gift.get_frame_for_type(type))
	sprite.modulate = Gift.get_color_for_type(type)

func _on_body_entered(body) -> void:
	if not (body is Gift): return
	body = body as Gift
	
	# @TODO: animation/delay/keep for a bit/whatever
	var is_good : bool = body.type == type
	body.kill(is_good)
	if is_good:
		num_delivered += 1
		gift_delivered.emit(body)

func set_width(w:float) -> void:
	var total_size := Vector2(w, BASKET_HEIGHT)
	var half_y := 0.5*total_size.y
	var shape := RectangleShape2D.new()
	shape.size = total_size
	col_shape_node.shape = shape
	col_shape_node.position.y = -half_y
	
	var sprite_scale := total_size / 256.0
	sprite.set_scale(sprite_scale)
	sprite.material.set_shader_parameter("scale", sprite_scale)
	sprite.position.y = -half_y
	sprite_type.position.y = -half_y
	sprite_type.set_scale(0.35*min(total_size.x, total_size.y)*Vector2.ONE / 256.0)

func has_enough_gifts() -> bool:
	return num_delivered >= GIFT_DELIVERED_TARGET
