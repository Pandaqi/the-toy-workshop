extends CanvasLayer
class_name Background

@export var baskets : Baskets
@export var score_label : Label
@export var anim_player : AnimationPlayer

func _ready() -> void:
	baskets.score_changed.connect(_on_score_changed)
	_on_score_changed(0)

func _on_score_changed(s:float) -> void:
	score_label.set_text(str(floori(s)))
	anim_player.play("score_changed")
