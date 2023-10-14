extends Control
	
var money_format_string = "MONEY: ${value}"
var time_format_string = "TIME: {value}"
	
var _game_storage

func _ready():
	_game_storage = get_node("/root/game_storage")

func _process(delta):
	_update_money_label()
	_update_time_label()

func _update_money_label():
	$money_label.text = money_format_string.format({"value": _game_storage.player_money})
	
func _update_time_label():
	var seconds = _game_storage.timer_seconds % 60
	var minutes = (_game_storage.timer_seconds / 60) % 60
	
	var format_string = "{minutes}:{seconds}"
	var value = format_string.format({"minutes": minutes, "seconds": str("%02d" % seconds)})
	$time_label.text = time_format_string.format({"value": value})
