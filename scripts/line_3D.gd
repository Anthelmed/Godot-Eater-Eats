@tool
class_name Line3D 
extends Path3D
	
@export var thickness: float = 0.5 :
	get:
		return thickness
	set(value):
		thickness = value
		_update_line()
		
@export var mesh_instance: MeshInstance3D :
	get:
		return mesh_instance
	set(value):
		mesh_instance = value
		_update_line()

func _on_curve_changed():
	_update_line()
	
var surfaceTool = SurfaceTool.new()

func _update_line():
	if (mesh_instance == null || curve.point_count <= 2): return
	
	var curve_length = curve.get_baked_length()
	var curve_baked_point_count: int = (curve_length / curve.bake_interval)
		
	var vertices: Array[Vector3] = []
	var triangles: Array[int] = []
	var uvs: Array[Vector2] = []
	var colors: Array[Color] = []
	var normals: Array[Vector3] = []
	
	vertices.resize(curve_baked_point_count * 2)
	triangles.resize(2 * (curve_baked_point_count - 1) * 3)
	uvs.resize(curve_baked_point_count * 2)
	colors.resize(curve_baked_point_count * 2)
	normals.resize(curve_baked_point_count * 2)
		
	var vertexIndex = 0
	var triangleIndex = 0
	
	var simplified_curve_indexes = _calculate_simplified_curve_indexes(curve_baked_point_count, curve_length)
	
	for index in simplified_curve_indexes:
		var percent = _calculate_percent(index, curve_baked_point_count)
		var offset = _calculate_offset(percent, curve_length)
		
		var position = curve.sample_baked(offset, true)
		
		var up = curve.sample_baked_up_vector(offset, true) if (curve.up_vector_enabled) else Vector3(0, 1, 0)
		var forward = _calculate_forward(index, curve_baked_point_count, curve_length)
		var left = up.cross(forward)
		
		var vertexA = position + left * thickness * 0.5
		var vertexB = position - left * thickness * 0.5
		
		var uvA = Vector2(0, percent)
		var uvB = Vector2(1, percent)
		
		vertices.insert(vertexIndex, vertexA)
		vertices.insert(vertexIndex + 1, vertexB)
		
		if (index < curve_baked_point_count - 1):
			triangles.insert(triangleIndex, vertexIndex)
			triangles.insert(triangleIndex + 1, vertexIndex + 2)
			triangles.insert(triangleIndex + 2, vertexIndex + 1)
			
			triangles.insert(triangleIndex + 3, vertexIndex + 1)
			triangles.insert(triangleIndex + 4, vertexIndex + 2)
			triangles.insert(triangleIndex + 5, vertexIndex + 3)
		
		uvs.insert(vertexIndex, uvA)
		uvs.insert(vertexIndex + 1, uvB)
		
		colors.insert(vertexIndex, Color.WHITE)
		colors.insert(vertexIndex + 1, Color.WHITE)
		
		normals.insert(vertexIndex, up)
		normals.insert(vertexIndex + 1, up)
		
		vertexIndex += 2
		triangleIndex += 6
		
	_redraw_mesh(vertices, triangles, uvs, colors, normals)

func _redraw_mesh(vertices, triangles, uvs, colors, normals):
	surfaceTool.clear()
	
	surfaceTool.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	for index in triangles:
		var vertex = vertices[index]
		var uv = uvs[index]
		var color = colors[index]
		var normal = normals[index]
		
		surfaceTool.set_uv(uv)
		surfaceTool.set_color(color)
		surfaceTool.set_normal(normal)
		surfaceTool.add_vertex(vertex)
	
	surfaceTool.generate_normals()
	surfaceTool.generate_tangents()
	
	var mesh = surfaceTool.commit()
	mesh_instance.mesh = mesh
	
func _calculate_simplified_curve_indexes(max_index, max_distance):
	var curve_indexes: Array[int] = []
	var curve_angles: Array[float] = []
	
	curve_indexes.append(0)
	curve_angles.append(0)
		
	for index in max_index:
		if (index == 0): continue
		if (index == max_index - 1): break
		
		var percent = _calculate_percent(index, max_index)
		var offset = _calculate_offset(percent, max_distance)
		
		var forwardA = _calculate_forward(index, max_index, max_distance)
		var forwardB = _calculate_forward(index + 1, max_index, max_distance)
		
		var dot = forwardA.dot(forwardB)
		var last_angle = curve_angles[-1]
		
		if (abs(last_angle - dot) > 0.0001):
			curve_indexes.append(index)
			curve_angles.append(dot)
		
	curve_indexes.append(max_index - 1)
	curve_angles.append(0)
		
	return curve_indexes
	
func _calculate_percent(index, max_index):
	return inverse_lerp(0, max_index - 1, index)
	
func _calculate_offset(percent, max_distance):
	return lerpf(0.0001, max_distance - 0.0001, percent)
	
func _calculate_forward(index, max_index, max_distance):
	var indexA = index;
	var indexB = index + 1
	
	var percentA = _calculate_percent(index, max_index)
	var percentB = _calculate_percent(index + 1, max_index)
	
	var offsetA = _calculate_offset(percentA, max_distance)
	var offsetB = _calculate_offset(percentB, max_distance) if (index < max_index - 1) else offsetA + 0.0001
	
	var positionA = curve.sample_baked(offsetA, true)
	var positionB = curve.sample_baked(offsetB, true)
	
	return (positionB - positionA).normalized()
