class_name ScoreUI extends Node

@export var _scoreLabel: Label

var _playerKillCounter: PlayerKillCounter

func InjectBeforeReady(diContainer: DIContainer):
	_playerKillCounter = diContainer.rootContainer.GetByClassType(PlayerKillCounter)

func _process(delta):
	_scoreLabel.text = str(_playerKillCounter.killsCount)
