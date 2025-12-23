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
var type : Type

signal killed(g:Gift)

static func get_all_types() -> Array[Type]:
	var arr : Array[Type] = []
	arr.assign(Type.values())
	return arr

static func get_frame_for_type(tp:Type) -> int:
	return Type.values().find(tp)

static func get_color_for_type(tp:Type) -> Color:
	return COLORS[Gift.get_frame_for_type(tp)]

func _physics_process(_delta:float) -> void:
	check_if_off_screen()

func check_if_off_screen() -> void:
	var pos := global_position
	var vp := get_viewport().get_visible_rect().size
	if pos.y <= vp.y: return
	kill()

func set_type(tp:Type) -> void:
	sprite.set_frame(Gift.get_frame_for_type(tp))

func kill(good := false) -> void:
	print("Gift killed. Good? ", good)
	queue_free()
	killed.emit(self)
