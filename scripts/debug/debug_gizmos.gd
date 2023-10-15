class_name DebugGizmos
extends Node

var _mesh_instances: Array[MeshInstance3D] = []
var _primitive_meshes: Array[DebugGizmoPrimitiveMesh] = []

var _redraw: bool = false

func add_primitive_mesh(primitive_mesh: DebugGizmoPrimitiveMesh):
	_primitive_meshes.append(primitive_mesh)
	_redraw = true
	
func remove_primitive_mesh(primitive_mesh: DebugGizmoPrimitiveMesh):
	_primitive_meshes.erase(primitive_mesh)
	_redraw = true

func _process(_delta):
	if !_redraw: return
	
	_redraw = false
	
	for mesh_instance in _mesh_instances:
		mesh_instance.queue_free()
	
	_mesh_instances.clear()
	
	for primitive_mesh in _primitive_meshes:
		var mesh_instance = MeshInstance3D.new()
		
		add_child(mesh_instance)
		_mesh_instances.append(mesh_instance)
		
		mesh_instance.global_position = primitive_mesh.get_position()
		mesh_instance.global_rotation = primitive_mesh.get_rotation()
		mesh_instance.scale = primitive_mesh.get_scale()
		mesh_instance.mesh = primitive_mesh.get_mesh()
