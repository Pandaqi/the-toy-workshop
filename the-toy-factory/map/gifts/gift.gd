extends RigidBody2D
class_name Gift

enum Type
{
	RED,
	GREEN,
	BLUE,
	YELLOW
}

func _physics_process(_delta:float) -> void:
	check_if_off_screen()

func check_if_off_screen() -> void:
	var pos := global_position
	var vp := get_viewport().get_visible_rect().size
	if pos.y <= vp.y: return
	kill()

func kill() -> void:
	queue_free()
