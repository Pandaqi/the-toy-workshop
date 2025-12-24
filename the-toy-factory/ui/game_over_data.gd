extends GameOverDataSystem
class_name GameOverData

var score : int = 0
var time_played : int = 0
var gifts_failed : int = 0

func get_message() -> String:
	var msg := tr("GAME_OVER_MESSAGE_GOOD")
	var stats := "{tr_1}: {time_played}\n{tr_2}: {gifts_delivered}\n{tr_3}: {score}".format({
		"tr_1": tr("TIME"),
		"time_played": time_played,
		"tr_2": tr("GIFTS_FAILED"),
		"gifts_failed": gifts_failed,
		"tr_3": tr("SCORE"),
		"score": score
	})
	return msg + "\n" + stats
