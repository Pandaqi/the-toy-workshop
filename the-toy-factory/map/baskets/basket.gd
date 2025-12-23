extends Node2D
class_name Basket

@export var area : Area2D
@export var col_shape_node : CollisionShape2D
@export var sprite : Sprite2D

func _ready() -> void:
	area.body_entered.connect(_on_body_entered)

func _on_body_entered(body) -> void:
	if not (body is Gift): return
	body = body as Gift
	body.kill()
	# @TODO: check if type actually matches + animation/delay/keep for a bit/whatever
	print("GIFT DELIVERED!")

func set_width(w:float) -> void:
	var total_size := Vector2(w, 64)
	var shape := RectangleShape2D.new()
	shape.size = total_size
	col_shape_node.shape = shape
	
	sprite.set_scale(total_size / 128.0)
