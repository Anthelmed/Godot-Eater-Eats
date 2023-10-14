extends Node3D

func calculate_navigation_path(origin: Vector3, destination: Vector3):
	var map_rid: RID = get_world_3d().get_navigation_map()
	var navigation_path = NavigationServer3D.map_get_path(map_rid, snap_position(origin), snap_position(destination), true)
	navigation_path = snap_path(navigation_path)
		
	return navigation_path

func snap_position(point: Vector3):
	return point.snapped(Vector3(0.333, 1, 0.333))
	
func snap_path(navigation_path: PackedVector3Array):
	var snapped_path: PackedVector3Array
	
	for point in navigation_path:
		snapped_path.append(snap_position(point))
		
	return snapped_path
