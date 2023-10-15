class_name DebugGizmoPrimitiveMesh
extends Node

enum Mesh_Type {
	Box,
	Capsule,
	Cylinder,
	Plane,
	Quad,
	Prism,
	Sphere,
	Torus
}

var _mesh: PrimitiveMesh
var _position: Vector3
var _rotation: Vector3
var _scale: Vector3

func _init(mesh_type: Mesh_Type = Mesh_Type.Box, material = StandardMaterial3D.new(), position: Vector3 = Vector3.ZERO, rotation: Vector3 = Vector3.ZERO, scale: Vector3 = Vector3.ONE):
	_mesh = _instantiate_mesh(mesh_type)
	_mesh.material = material
	
	_position = position
	_rotation = rotation
	_scale = scale
	
func get_mesh():
	return _mesh
	
func get_position():
	return _position
	
func get_rotation():
	return _rotation
	
func get_scale():
	return _scale
		
func _instantiate_mesh(mesh_type: Mesh_Type):
	match mesh_type:
		Mesh_Type.Box:
			return BoxMesh.new()
		Mesh_Type.Capsule:
			var capsule_mesh = CapsuleMesh.new()
			capsule_mesh.radial_segments = 8
			capsule_mesh.rings = 2
			return capsule_mesh
		Mesh_Type.Cylinder:
			var cylinder_mesh = CylinderMesh.new()
			cylinder_mesh.radial_segments = 8
			cylinder_mesh.rings = 1
			return cylinder_mesh
		Mesh_Type.Plane:
			return PlaneMesh.new()
		Mesh_Type.Quad:
			return QuadMesh.new()
		Mesh_Type.Prism:
			return PrismMesh.new()
		Mesh_Type.Sphere:
			var sphere_mesh = SphereMesh.new()
			sphere_mesh.radial_segments = 8
			sphere_mesh.rings = 4
			return sphere_mesh
		Mesh_Type.Torus:
			var torus_mesh = TorusMesh.new()
			torus_mesh.radial_segments = 8
			torus_mesh.rings = 4
			return torus_mesh
