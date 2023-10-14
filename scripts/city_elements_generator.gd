extends Node3D

@export var city_element_scenes: Array[PackedScene]
@export var valid_placements: Array[Node]

func _ready():
	_instanciate_buildings()
	
func _instanciate_buildings():
	for valid_placement in valid_placements:
		var random_city_element_scene_index = randi() % city_element_scenes.size()
		var city_element_scene_instance = city_element_scenes[random_city_element_scene_index].instantiate()
		
		valid_placement.add_child(city_element_scene_instance)
