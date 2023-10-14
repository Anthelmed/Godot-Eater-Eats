class_name DebugGizmoMesh
extends Node

var position: Vector3
var rotation: Quaternion
var scale: Vector3
var color: Color

func _init(_position: Vector3 = Vector3.ZERO, _rotation: Quaternion = Quaternion.IDENTITY, _scale: Vector3 = Vector3.ONE, _color: Color = Color.WHITE):
	position = _position
	rotation = _rotation
	scale = _scale
	color = _color
