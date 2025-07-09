class_name BaseState2D extends RewindableState

@export var animation_name: String

var _diContainer: DIContainer
var _playerInput: PlayerInput

var _unit: Unit
var entity: Unit:
	get():
		return _unit
		
var unit: Unit:
	get():
		return _unit
		
func InjectBeforeReady(diContainer: DIContainer):
	_diContainer = diContainer
	_unit = diContainer.ownerContainer.get_parent()
	_playerInput = diContainer.ownerContainer.GetByClassType(PlayerInput)

func TransitionTo(toState: String):
	state_machine.transition(toState)
