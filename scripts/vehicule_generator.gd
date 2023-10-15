class_name VehiculeGenerator
extends Node3D

@export var vehicule_scenes: Array[PackedScene]

@export var up_spawning_points: Array[Node3D]
@export var down_spawning_points: Array[Node3D]
@export var left_spawning_points: Array[Node3D]
@export var right_spawning_points: Array[Node3D]

@export var spawning_interval: float = 1
@export var max_vehicule_count: int = 10

var _directions = {
	0: Vector3(0, 0, 1),
	1: Vector3(1, 0, 0),
	2: Vector3(0, 0, -1),
	3: Vector3(-1, 0, 0),
}
var _direction_spawning_points = {}

var _timer = Timer.new()
var _vehicule_instances = []

var _road_traffic
	
func get_vehicule_instances():
	return _vehicule_instances

func _ready():
	_direction_spawning_points[Vector3(0, 0, 1)] = up_spawning_points
	_direction_spawning_points[Vector3(1, 0, 0)] = left_spawning_points
	_direction_spawning_points[Vector3(0, 0, -1)] = down_spawning_points
	_direction_spawning_points[Vector3(-1, 0, 0)] = right_spawning_points
	
	_road_traffic = get_node("/root/road_traffic")
	
	_initialize_timer()

func _initialize_timer():
	_timer.wait_time = spawning_interval
	_timer.timeout.connect(_instantiate_vehicule)
	add_child(_timer)
	
	_timer.start()
	
func _instantiate_vehicule():
	if (_vehicule_instances.size() == max_vehicule_count): return
		
	var vehicule_trip = _get_vehicule_trip()
	
	var vehicule_instance: NPCVehicule = _get_random_vehicule_instance()
	var navigation_path = _road_traffic.calculate_navigation_path(vehicule_trip.origin.global_position, vehicule_trip.destination.global_position)
	
	_vehicule_instances.append(vehicule_instance)
	vehicule_instance.path_end_reached.connect(_destroy_vehicule)
	
	add_child(vehicule_instance)
	
	vehicule_instance.global_position = vehicule_trip.origin.global_position
	vehicule_instance.global_rotation = vehicule_trip.origin.global_rotation
	
	vehicule_instance.set_navigation_path(navigation_path)
	
func _destroy_vehicule(vehicule_instance: NPCVehicule):
	var navigation_path = vehicule_instance.get_navigation_path()
	
	_vehicule_instances.erase(vehicule_instance)
	vehicule_instance.path_end_reached.disconnect(_destroy_vehicule)
	
	vehicule_instance.queue_free()

func _get_vehicule_trip():
	var random_direction = _directions[randi() % _directions.size()]
	
	var origin_points = _direction_spawning_points[random_direction]
	var destination_points = _direction_spawning_points[random_direction * -1]
		
	var origin_point = origin_points[randi() % origin_points.size()]
	var destination_point = destination_points[randi() % destination_points.size()]
			
	return { "origin": origin_point, "destination": destination_point }
		
func _get_random_vehicule_instance():
	var random_index = randi() % vehicule_scenes.size()
	return vehicule_scenes[random_index].instantiate()
