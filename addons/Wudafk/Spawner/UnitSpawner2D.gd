class_name UnitSpawner2D extends UnitSpawnerBase

@export_category("Spawn")
@export var _spawnRadius: float = 3
@export var _checkPositionFreeRadius: float = 0.5

func _trySpawn():
	var spawnPositionResult = getMonsterSpawnPosition(_spawnRadius, _checkPositionFreeRadius, _spawnPositionContainer.global_position)
	if not spawnPositionResult.found:
		
		return false
		
	var unit: Unit = _spawnUnitFromPool()
	if unit:   
		var unitDIContainer: DIContainer = unit.diContainer
		var unitNetworkData: UnitNetworkData = unitDIContainer.GetByClassType(UnitNetworkData)
		unit.unitData.SetHealth(unit.unitData.GetMaxHealth())
		if unitNetworkData:
			unitNetworkData.UpdateUnitNetworkData(unit.unitData)
	
		if unit.unitSystemData:
			var customVectorData = unit.unitSystemData.customVectorData
			customVectorData.x = spawnPositionResult.position.x
			customVectorData.y = spawnPositionResult.position.y
			unit.unitSystemData.customVectorData = customVectorData
			unit.unitSystemData.teleportRequestedThisTick = true
	return true
	
func getRandomQuadPosition(spawnRadius: float = 1) -> Vector3:
	var spwn_rad = spawnRadius
	return Vector3(randf_range(-spwn_rad, spwn_rad), 0, randf_range(-spwn_rad, spwn_rad))

func getMonsterSpawnPosition(spawnRadius: float, checkPositionFreeRadius: float, cornerPoint: Vector2) -> SpawnPositionResult2D:
	return SpawnPositionResult2D.new(true, Vector2(randf_range(-0.3,0.3), 0) + cornerPoint)

	var maxAttempts = 10
	var attempts = 0
	while true:
		var pos = getRandomQuadPosition(spawnRadius)
		
		if isSpawnPositionFree(cornerPoint + pos, checkPositionFreeRadius):
			return SpawnPositionResult2D.new(true, cornerPoint + pos)
		else:
			attempts=attempts+1
			if attempts >= maxAttempts:
				break
	return SpawnPositionResult2D.new(false, cornerPoint)

func isSpawnPositionFree(pos: Vector3, check_radius: float) -> bool:
	var self_ = self as Node as Node2D
	var space_state = self_.get_world_2d().direct_space_state

	var query = PhysicsShapeQueryParameters3D.new()
	query.set_shape(SphereShape3D.new())
	(query.shape as SphereShape3D).radius = check_radius
	
	query.transform = Transform3D(Basis(), pos)
	
	var checkCollisionMask = 1
	query.collision_mask = checkCollisionMask 
	var result = space_state.intersect_shape(query)
	
	return result.is_empty()

class SpawnPositionResult2D:
	var found: bool
	var position: Vector2

	func _init(p_found: bool = false, p_position: Vector2 = Vector2.ZERO):
		self.found = p_found
		self.position = p_position
