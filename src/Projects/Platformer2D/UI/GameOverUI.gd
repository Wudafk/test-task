class_name GameOverUI extends Node

var _restartGameManager: RestartGameManager

func InjectBeforeReady(diContainer: DIContainer):
	_restartGameManager = diContainer.rootContainer.GetByClassType(RestartGameManager)

func _on_start_again_button_button_down() -> void:
	_restartGameManager.RestartGame()
