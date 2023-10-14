class_name NPCVehicule 
extends VehiculeGeneric

@export var distance_path_point_threshold: float = 0.75

var _road_traffic
var _debug_gizmos
var _debug_gizmo_line

var _navigation_path: PackedVector3Array
var _current_path_point_index: int = 0

var _lane_path_offset: float

signal path_end_reached(instance: NPCVehicule)

func get_navigation_path():
	return _navigation_path
	
func set_navigation_path(value):
	_navigation_path = value

	_debug_gizmo_line = DebugGizmoLine.new(_navigation_path, 1.0, Color.RED)
	_debug_gizmos.add_line(_debug_gizmo_line)

	_calculate_lane_path_offset()

func _ready():
	_road_traffic = get_node("/root/road_traffic")
	_debug_gizmos = get_node("/root/debug_gizmos")
	
func _exit_tree():
	_debug_gizmos.remove_line(_debug_gizmo_line)
	
func _physics_process(delta):
	super(delta)
	
	drive()
	
func drive():	
	var forward = transform.basis.z
	var left = transform.basis.x
		
	var target_path_point = _navigation_path[_current_path_point_index] + left * _lane_path_offset
	
	var point_direction = target_path_point.direction_to(global_position)
		
	var steering_multiplier = left.dot(point_direction) * -1
	var engine_force_multiplier = forward.dot(point_direction) * -1
				
	set_steering_and_engine_force(steering_multiplier, engine_force_multiplier)
		
	if (global_position.distance_to(target_path_point) <= distance_path_point_threshold):
		if (_current_path_point_index < _navigation_path.size() - 1):
			_current_path_point_index += 1
		else:
			path_end_reached.emit(self)

func _calculate_lane_path_offset():
	var first_point = _navigation_path[0]
	var lane_side = global_position.direction_to(first_point).snapped(Vector3(1.0, 0.0, 1.0))
		
	_lane_path_offset = global_position.distance_to(first_point) * -1
