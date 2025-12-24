extends PlayerSystem
class_name Player

var slider : SliderPlayer

func _ready() -> void:
	module_input.quick_pressed.connect(_on_quick_pressed)
	module_input.hold_started.connect(_on_hold_started)
	module_input.hold_ended.connect(_on_hold_ended)
	
	killed.connect(_on_killed)

func _physics_process(_delta:float) -> void:
	stick_visualizer_to_slider()

func stick_visualizer_to_slider() -> void:
	if not slider: return
	var vis := module_input.button_visualizers[0]
	vis.global_position = slider.global_position

func attach_slider(s:SliderPlayer) -> void:
	slider = s
	stick_visualizer_to_slider()

func _on_quick_pressed() -> void:
	slider._on_quick_press()

func _on_hold_started() -> void:
	slider._on_hold_started()

func _on_hold_ended(_time:float) -> void:
	slider._on_hold_ended()

func _on_killed() -> void:
	slider = null
	module_input.clear_button_visualizers()
