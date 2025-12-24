extends Resource
class_name ConfigData

@export_group("Map")
@export var add_walls := true

@export_subgroup("Sliders")
@export var num_sliders := 13
@export var slider_move_speed := 14.0
@export var slider_move_speed_mult_hold := 12.0
@export var slider_y_dist_from_edge := 0.18 # ~viewport height
@export var move_fixed_sliders := false
@export var slider_smooth_change_speed := true
@export var slider_smooth_change_delta := 9.0 # how quickly that smooth interpolation happens

@export_subgroup("Baskets")
@export var num_baskets := 4
@export var basket_height := 96.0
@export var basket_num_gifts_target := 5

@export_subgroup("Edges")
@export var edge_thickness := 18.0
@export var edge_dist_break := 0.275 # ~viewport height

@export_subgroup("Gifts")
@export var min_gifts_on_screen := 1
@export var max_gifts_on_screen_per_player := 1
@export var max_gifts_on_screen_default := 2
@export var num_gifts_on_screen_factor := 1.0
@export var gift_size_base := 16
@export var gift_size_randomness := 8
@export var allow_different_gift_sizes := false

@export_group("Score")
@export var score_base := 10.0
@export var score_bonus_speed := 10.0
@export var score_bonus_speed_max_duration := 10.0
@export var score_bonus_fewer_gifts_destroyed := 10.0
@export var score_bonus_fewer_gifts_max := 5
@export var score_penalty_failed := -3.0
@export var lose_points_for_failed_gifts := true
