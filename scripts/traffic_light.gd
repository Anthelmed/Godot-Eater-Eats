class_name TrafficLight
extends Node3D

@export var default_action_state: Action_State = Action_State.MOVE_FORWARD
@export var action_stop_duration: float = 30
@export var action_slow_down_duration: float = 3
@export var action_move_forward_duration: float = 30
@export var stopping_distance: float = 1

enum Action_State {
	MOVE_FORWARD = 1, 
	SLOW_DOWN = 2, 
	STOP = 3
}

var _current_action_state: Action_State 
var action_duration = {}

var _timer = Timer.new()

func _ready():
	_current_action_state = default_action_state
	action_duration = {
		Action_State.MOVE_FORWARD: action_move_forward_duration,
		Action_State.SLOW_DOWN: action_slow_down_duration,
		Action_State.STOP: action_stop_duration
	}
	
	_initialize_timer()
	_reset_timer()

func _initialize_timer():
	_timer.set_one_shot(true)
	_timer.timeout.connect(_next_action_state)
	
	add_child(_timer)
	
func _reset_timer():
	_timer.wait_time = action_duration[_current_action_state]
	
	_timer.start()

func _next_action_state():
	var _current_action_state = _current_action_state % Action_State.keys().size() + 1
	
	_reset_timer()
