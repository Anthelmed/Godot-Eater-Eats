class_name PlayerCamera 
extends Camera3D

@export var target: Node3D
@export var offset: Vector3
@export_range(0.0, 1.0) var damping: float = 0.1

var _target_global_position: Vector3

func _ready():
	_target_global_position = target.global_position

func _process(delta):
	_target_global_position = _target_global_position.lerp(target.global_position, 1 - damping)
	global_position = _target_global_position + offset
	look_at(_target_global_position)
