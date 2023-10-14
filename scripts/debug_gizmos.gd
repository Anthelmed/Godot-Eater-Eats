extends Node

var _lines: Array[PackedVector3Array] = []

var _immediate_mesh

func add_line(line: PackedVector3Array):
	_lines.append(line)
	
func remove_line(line: PackedVector3Array):
	_lines.erase(line)

func _ready():
	_initialize()

func _initialize():
	var mesh_instance_3d = MeshInstance3D.new()
	_immediate_mesh = ImmediateMesh.new()
	
	mesh_instance_3d.mesh = _immediate_mesh
	mesh_instance_3d.cast_shadow = false
	
	add_child(mesh_instance_3d)

func _process(_delta):
	_immediate_mesh.clear_surfaces()
	
	_draw_lines()

func _draw_lines():
	var material = StandardMaterial3D.new()
	
	for line in _lines:
		_immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINE_STRIP, material)
		
		for point in line:
			_immediate_mesh.surface_add_vertex(point)
			
		_immediate_mesh.surface_end()
		
		material.no_depth_test = true
		material.shading_mode = StandardMaterial3D.SHADING_MODE_UNSHADED
		material.albedo_color = Color.RED
