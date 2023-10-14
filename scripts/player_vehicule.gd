class_name PlayerVehicule 
extends VehiculeGeneric

func _physics_process(delta):
	super(delta)
	
	var steering_multiplier = Input.get_axis("player_car_right", "player_car_left")
	var engine_force_multiplier = Input.get_axis("player_car_back", "player_car_forward")
	
	set_steering_and_engine_force(steering_multiplier, engine_force_multiplier)
