class_name CharacterInputController extends Node

@export var _unitInput : PlayerInput

func InjectBeforeReady(diContainer: DIContainer):
	_unitInput = diContainer.ownerContainer.GetByClassType(PlayerInput)
