class_name NameEntityBarUI

extends Node

@export var hero_name_label: Label

var _unitNetworkData: UnitNetworkData
var _gameTime: GameTime

func InjectBeforeReady(diContainer: DIContainer):
	_unitNetworkData = diContainer.ownerContainer.GetByClassType(UnitNetworkData)
	_gameTime = diContainer.rootContainer.GetByClassType(GameTime)

func _ready():
	pass
	
func _enter_tree():
	if _gameTime:
		_gameTime.before_tick_loop.connect(_gather)
		
func _exit_tree():
	_gameTime.before_tick_loop.disconnect(_gather)
	
func _gather():
	hero_name_label.text = _unitNetworkData.unitName
