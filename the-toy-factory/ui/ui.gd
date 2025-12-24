extends CanvasLayer
class_name UI

@export var baskets : Baskets
@export var gifts : Gifts
@export var audio_victory : AudioStreamPlayer
@export var game_over_menu : GameOverMenu
@export var game_over_data : GameOverData
var game_over := false

func _ready() -> void:
	baskets.game_over.connect(_on_game_over)

func _on_game_over() -> void:
	if game_over: return

	game_over = true
	audio_victory.play()
	
	var final_score := roundi(baskets.score)
	game_over_data.score = final_score
	game_over_data.time_played = floori((Time.get_ticks_msec() - baskets.time_started) / 1000.0)
	game_over_data.gifts_failed = gifts.num_failed
	
	game_over_menu.activate(game_over_data)
