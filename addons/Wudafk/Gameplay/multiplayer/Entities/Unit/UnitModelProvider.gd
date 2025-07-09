class_name UnitModelProvider extends Node

var _unitModel: Node

func InjectBeforeReady(diContainer: DIContainer):
	_unitModel = diContainer.ownerContainer.GetByNodeName("UnitModel")
	
@export var global_transform: Transform3D:
	get:
		return _unitModel.global_transform
	set(value):
		_unitModel.global_transform = value
		
@export var global_quaternion: Quaternion:
	get:
		return _unitModel.quaternion
	set(value):
		_unitModel.quaternion = value
