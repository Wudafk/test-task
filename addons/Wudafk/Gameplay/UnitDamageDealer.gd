class_name UnitDamageDealer extends Node

var _unit: Unit
var _unitNetworkData: UnitNetworkData
var _unitSystemData: UnitSystemData
var _damageManager: iDamageManager

func InjectBeforeReady(diContainer: DIContainer):
	_unit = diContainer.ownerContainer.get_parent()
	_unitNetworkData = diContainer.ownerContainer.GetByClassType(UnitNetworkData)
	_unitSystemData = diContainer.ownerContainer.GetByClassType(UnitSystemData)
	_damageManager = diContainer.rootContainer.GetByClassType(RPGDamageManager)

func DealDamage(target: Unit, damage: float) -> void:
	if target.unitSystemData.isDied:
		return
	_damageManager.ApplyDamage(target, damage, _unit)
