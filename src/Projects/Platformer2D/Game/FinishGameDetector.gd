class_name FinishGameDetector extends Node

var _restartGameManager: RestartGameManager

func InjectBeforeReady(diContainer: DIContainer):
	_restartGameManager = diContainer.rootContainer.GetByClassType(RestartGameManager)

func _on_body_entered(body: Node2D) -> void:
	if not (body as Node) is Hero:
		return
		
	_restartGameManager.RestartGame()
