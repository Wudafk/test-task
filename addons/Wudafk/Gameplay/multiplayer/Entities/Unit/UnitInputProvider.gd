class_name UnitInputProvider extends Node

var _unitInput: PlayerInput

func InjectBeforeReady(diContainer: DIContainer):
	_unitInput = diContainer.ownerContainer.GetByClassType(PlayerInput)
	

var unitInput: PlayerInput:
	get:
		return _unitInput
