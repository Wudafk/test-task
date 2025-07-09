class_name GameCameraController extends iCameraController

@export var _cameraPrefab: PackedScene

var container: Node
var target: Node

var _camera: Node

func _enter_tree():
	_camera = _cameraPrefab.instantiate()
	self.add_child(_camera)

func _process(delta):
	if _camera && not _camera.get_parent():
		self.add_child(_camera)
	
func SetFollowTarget(target_: Node):
	var entityTarget: Entity = target_
	
	if _camera.get_parent():
		_camera.get_parent().remove_child(_camera)
		pass

	entityTarget.add_child(_camera)
	target = entityTarget
