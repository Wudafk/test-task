class_name RestartGameManager extends Node

var _gameTime: GameTime

func InjectBeforeReady(diContainer: DIContainer):
	_gameTime = diContainer.rootContainer.GetByClassType(GameTime)

func RestartGame():
	var current_scene_path = get_tree().current_scene.scene_file_path
	await _gameTime.after_tick_loop
	get_tree().change_scene_to_file(current_scene_path)
	
