extends Node

@export var player_money: int = 0
@export var timer_seconds: int = 30 * 60

var _timer = Timer.new()

func _ready():
	_initialize_timer()

func _initialize_timer():
	_timer.wait_time = 1
	_timer.timeout.connect(_decrease_timer)
	add_child(_timer)
	
	_timer.start()
	
func _decrease_timer():
	timer_seconds -= 1
