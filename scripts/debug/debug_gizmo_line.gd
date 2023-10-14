class_name DebugGizmoLine
extends Node

var points: PackedVector3Array
var thickness: float
var color: Color

func _init(_points: PackedVector3Array = [], _thickness: float = 1.0, _color: Color = Color.WHITE):
	points = _points
	thickness = _thickness
	color = _color
