class_name RPGDamageManager extends iDamageManager

var _gameTime: GameTime

func InjectBeforeReady(diContainer: DIContainer):
	_gameTime = diContainer.rootContainer.GetByClassType(GameTime)

func ApplyDamage(target: Unit, damage: float,
eventInstigator: Unit = null,
damageCauser: Unit = null) -> void:
	if target.unitDamageTaker.TakeDamage(damage):
		if eventInstigator:
			var killEventListener: iKillEventListener = eventInstigator.diContainer.GetByClassType(iKillEventListener)
			if killEventListener:
				killEventListener.OnKill(target)

func is_inherit_class(className: String):
	return className == "iDamageManager"
