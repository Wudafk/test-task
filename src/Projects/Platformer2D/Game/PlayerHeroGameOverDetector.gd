class_name PlayerHeroGameOverDetector extends Node

@export var _gameOverPopupUIPrefab: PackedScene

var _unitSystemData: UnitSystemData
var _gameTime: GameTime
var _uiManager: UIManager

var _gameOverPopupUI: GameOverUI

func InjectBeforeReady(diContainer: DIContainer):
	_unitSystemData = diContainer.ownerContainer.GetByClassType(UnitSystemData)
	_gameTime = diContainer.rootContainer.GetByClassType(GameTime)
	_uiManager = diContainer.rootContainer.GetByClassType(UIManager)

func _enter_tree() -> void:
	if not multiplayer.is_server():
		return
	if _gameTime:
		_gameTime.after_tick_loop.connect(_gather)

func _exit_tree() -> void:
	if _gameTime.after_tick_loop.is_connected(_gather):
		_gameTime.after_tick_loop.disconnect(_gather)

func _gather():
	if _unitSystemData.isDied && (not _gameOverPopupUI || not _gameOverPopupUI.visible):
		if not _gameOverPopupUI:
			_gameOverPopupUI = _uiManager.OpenPopup(_gameOverPopupUIPrefab)
		_gameOverPopupUI.visible = true
