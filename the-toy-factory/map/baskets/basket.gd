extends Node2D
class_name Basket

@export var area : Area2D
@export var col_shape_node : CollisionShape2D
@export var sprite : Sprite2D
@export var sprite_type : Sprite2D
@export var label_container : Node2D
@export var label : Label

var BASKET_HEIGHT := Global.config.basket_height
var GIFT_DELIVERED_TARGET := Global.config.basket_num_gifts_target

var num_delivered := 0
var type : Gift.Type

signal gift_delivered(g:Gift)

func _ready() -> void:
	area.body_entered.connect(_on_body_entered)
	update_label()

func set_type(tp:Gift.Type) -> void:
	type = tp
	sprite_type.set_frame(Gift.get_frame_for_type(type))
	
	var col := Gift.get_color_for_type(type)
	sprite.modulate = col
	label_container.modulate = col

func _on_body_entered(body:Node2D) -> void:
	if not (body is Gift): return

	var is_good := (body as Gift).is_type(type)
	if is_good:
		deliver_gift(body)
	
	body.kill(is_good)

func deliver_gift(g:Gift) -> void:
	num_delivered += 1
	gift_delivered.emit(g)
	update_label()

func update_label() -> void:
	label.set_text(str(num_delivered) + "/" + str(GIFT_DELIVERED_TARGET))

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
	
	var sprite_type_size := 0.35*minf(total_size.x, total_size.y)
	sprite_type.set_scale(sprite_type_size*Vector2.ONE / 256.0)
	
	label_container.position = sprite_type.position + 0.5 * Vector2.DOWN * sprite_type_size

func has_enough_gifts() -> bool:
	return num_delivered >= GIFT_DELIVERED_TARGET
