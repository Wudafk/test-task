class_name UnitRootProvider extends Node

@export var _unitRoot2: float
@export var _unitRoot: Node
@export var _instances: Array[Node]

func InjectBeforeReady(diContainer: DIContainer):
	_unitRoot = diContainer.ownerContainer.get_parent()

@export var unitRoot: CharacterBody3D:
	get:
		return _unitRoot

@export var global_transform: Transform3D:
	get:
		return _unitRoot.global_transform
	set(value):
		_unitRoot.global_transform = value
		
@export var global_quaternion: Quaternion:
	get:
		return _unitRoot.global_quaternion
	set(value):
		_unitRoot.global_quaternion = value

@export var global_position: Vector3:
	get:
		return _unitRoot.global_position
	set(value):
		_unitRoot.global_position = value

@export var velocity: Vector3:
	get:
		return _unitRoot.velocity
	set(value):
		_unitRoot.velocity = value
