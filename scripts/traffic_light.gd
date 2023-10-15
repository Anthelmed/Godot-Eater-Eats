class_name TrafficLight
extends Node3D

@export var default_action_state: Action_State = Action_State.MOVE_FORWARD
@export var action_stop_duration: float = 30
@export var action_slow_down_duration: float = 3
@export var action_move_forward_duration: float = 30
@export var stopping_distance: float = 2

var _debug_gizmos: DebugGizmos
var _debug_gizmo_primitive_mesh: DebugGizmoPrimitiveMesh
var _debug_material: StandardMaterial3D

enum Action_State {
	MOVE_FORWARD = 1, 
	SLOW_DOWN = 2, 
	STOP = 3
}

var action_state_color = {
	Action_State.MOVE_FORWARD: Color.GREEN,
	Action_State.SLOW_DOWN: Color.YELLOW,
	Action_State.STOP: Color.RED
}

var _current_action_state: Action_State 
var action_duration = {}

var _timer = Timer.new()

func _ready():
	_debug_gizmos = get_node("/root/debug_gizmos")
	
	_current_action_state = default_action_state
	action_duration = {
		Action_State.MOVE_FORWARD: action_move_forward_duration,
		Action_State.SLOW_DOWN: action_slow_down_duration,
		Action_State.STOP: action_stop_duration
	}
	
	_debug_material = StandardMaterial3D.new()
	_debug_material.no_depth_test = true
	_debug_material.shading_mode = StandardMaterial3D.SHADING_MODE_UNSHADED
	
	_initialize_timer()
	_reset_timer()


func _initialize_timer():
	_timer.set_one_shot(true)
	_timer.timeout.connect(_next_action_state)
	
	add_child(_timer)
	
func _reset_timer():
	_timer.wait_time = action_duration[_current_action_state]
	
	if _debug_gizmo_primitive_mesh != null:
		_debug_gizmos.remove_primitive_mesh(_debug_gizmo_primitive_mesh)
		
	_debug_material.albedo_color = action_state_color[_current_action_state]
	_debug_gizmo_primitive_mesh = DebugGizmoPrimitiveMesh.new(DebugGizmoPrimitiveMesh.Mesh_Type.Sphere, _debug_material, global_position)
	_debug_gizmos.add_primitive_mesh(_debug_gizmo_primitive_mesh)
	
	_timer.start()

func _next_action_state():
	_current_action_state = _current_action_state % Action_State.keys().size() + 1
	
	_reset_timer()
