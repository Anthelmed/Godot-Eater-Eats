class_name DebugGizmoSphere
extends Node

var position: Vector3
var radius: float
var color: Color

func _init(_position: Vector3 = Vector3.ZERO, _radius: float = 1.0, _color: Color = Color.WHITE):
	position = _position
	radius = _radius
	color = _color
