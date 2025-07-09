class_name SubViewportSizeCopy

extends Node

@export var _target_node: Control
@export var _mesh_instance_3d: MeshInstance3D
	
func _process(delta):
	self.size = _target_node.size
	var scale_2d = _target_node.size/100;
	_mesh_instance_3d.scale = Vector3(scale_2d.x, scale_2d.y, 1)
