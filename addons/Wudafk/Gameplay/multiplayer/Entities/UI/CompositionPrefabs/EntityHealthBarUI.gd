class_name EntityHealthBarUI

extends Node

@export var health: ProgressBar

var _unitData: UnitData
var _unitNetworkData: UnitNetworkData

var _gameTime: GameTime
func InjectBeforeReady(diContainer: DIContainer):
	_gameTime = diContainer.rootContainer.GetByClassType(GameTime)
	_unitNetworkData = diContainer.ownerContainer.GetByClassType(UnitNetworkData)
	
	_gameTime.before_tick_loop.connect(_gather)

func _exit_tree():
	_gameTime.before_tick_loop.disconnect(_gather)
	
func _gather():
	health.value = _unitNetworkData.healthProgress
