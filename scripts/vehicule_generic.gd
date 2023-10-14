class_name VehiculeGeneric
extends VehicleBody3D

@export var steering_intensity: float = 1
@export var acceleration_intensity: float = 10
@export_range(0.0, 1.0) var deceleration_factor: float = 0.9
@export var max_velocity: float = 2

func _physics_process(delta):
	if (linear_velocity.length() > max_velocity):
		linear_velocity *= deceleration_factor

func set_steering_and_engine_force(steering_multiplier: float, engine_force_multiplier: float):
	steering = steering_multiplier * steering_intensity
	engine_force = engine_force_multiplier * acceleration_intensity
