class_name UnitDamageTaker extends Node

var _unit: Unit
var _unitNetworkData: UnitNetworkData
var _unitSystemData: UnitSystemData

func InjectBeforeReady(diContainer: DIContainer):
	_unit = diContainer.ownerContainer.get_parent()
	_unitNetworkData = diContainer.ownerContainer.GetByClassType(UnitNetworkData)
	_unitSystemData = diContainer.ownerContainer.GetByClassType(UnitSystemData)

func TakeDamage(damage: float):
	_unit.unitData.ChangeHealth(damage)
	_unitNetworkData.UpdateGameplayHealthProgress(_unit.unitData)
	if _unit.unitData.health <= 0:
		_unitSystemData.SetDied(true)
		_unitSystemData.deathStartServerTime = Time.get_ticks_msec() / 1000.0
		_unitSystemData.respawnInSeconds = 3.0
		_unit.onFree.emit()
		return true
	return false
