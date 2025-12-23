extends CanvasLayer
class_name UI

@export var baskets : Baskets
@export var audio_victory : AudioStreamPlayer
# @export var game_over_menu : GameOverMenuCustom
var game_over := false

func _ready() -> void:
	baskets.game_over.connect(_on_game_over)

func _on_game_over() -> void:
	if game_over: return
	
	print("GAME OVER!")
	game_over = true
	audio_victory.play()
	
	# @TODO: save the game data on the resource
	#game_over_data.game_over_good = good
	#game_over_data.score = final_score
	#game_over_data.time_played = floori((Time.get_ticks_msec() - score.time_started) / 1000.0)
	#game_over_data.gifts_delivered = map_data.sleigh.module_gifts.num_delivered
	
	# @TODO: enable once I have it
	# game_over_menu.activate()
