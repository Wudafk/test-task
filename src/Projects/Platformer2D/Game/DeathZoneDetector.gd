class_name DeathZoneDetector extends Node

@export var _gameOverPopupUIPrefab: PackedScene

var _damageManager: iDamageManager

func InjectBeforeReady(diContainer: DIContainer):
	_damageManager = diContainer.rootContainer.GetByClassType(iDamageManager)

func _on_body_entered(body: Node2D) -> void:
	if not (body as Node) is Hero:
		return
	
	var hero: Unit = body as Node
	_damageManager.ApplyDamage(hero, hero.unitData.health * 2)
