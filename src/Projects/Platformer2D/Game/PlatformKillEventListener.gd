class_name PlatformKillEventListener extends iKillEventListener

var _playerKillCounter: PlayerKillCounter

func InjectBeforeReady(diContainer: DIContainer):
	_playerKillCounter = diContainer.rootContainer.GetByClassType(PlayerKillCounter)

func OnKill(target: Unit) -> void:
	_playerKillCounter.AddKills(1)
	pass

func is_inherit_class(className: String) -> bool:
	return className == "iKillEventListener"
