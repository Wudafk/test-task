class_name UnitSpawnerBase extends Entity

var _multiplayerSpawner: MultiplayerSpawner

@export_category("Unit")
@export var unitChunkPrefab: PackedScene

@export_category("Spawn")
@export var _maxUnits: int = 1
@export var _visualRootContainer: Node
@export var _spawnPositionContainer: Node

var _currentUnitsCount: int = 0

var _freePoolUnits: Array[Unit] = []

var _freeIdHelper: FreeIdHelper = FreeIdHelper.new()
var _activeUnits: Array[Unit] = []

var _gameTime: GameTime

func InjectBeforeReady(diContainer: DIContainer):
	_gameTime = diContainer.rootContainer.GetByClassType(GameTime)

func _ready():
	_freeIdHelper.GetNextFreeId()
	
	if not multiplayer.multiplayer_peer is OfflineMultiplayerPeer || multiplayer.is_server():
		_gameTime.before_tick_loop.connect(_gather)

func _enter_tree():
	_multiplayerSpawner = get_node("MultiplayerSpawner")
	_multiplayerSpawner.add_spawnable_scene(unitChunkPrefab.resource_path)
	
func _exit_tree():
	if multiplayer.multiplayer_peer is OfflineMultiplayerPeer || (multiplayer.multiplayer_peer && multiplayer.is_server()):
		if _gameTime.before_tick_loop.is_connected(_gather):
			_gameTime.before_tick_loop.disconnect(_gather)

func _gather():
	if not multiplayer.multiplayer_peer is OfflineMultiplayerPeer && not multiplayer.is_server():
		return
		
	if _visualRootContainer && not _visualRootContainer.visible:
		return
		
	if _currentUnitsCount < _maxUnits:
		if not self._trySpawn():
			return
		_currentUnitsCount+=1

func _trySpawn():
	return false
	
func _disconnectAllSignalConnections(target_signal: Signal):
	var connections_to_disconnect = target_signal.get_connections().duplicate()
	for connection_info in connections_to_disconnect:
		var target_callable = connection_info.callable
		if target_signal.is_connected(target_callable):
			target_signal.disconnect(target_callable)

func _unitToPool(unit: Unit):
	_disconnectAllSignalConnections(unit.onFree)
	unit.unitSystemData.SetDied(true)

	if unit.has_node("CollisionShape3D"):
		var collisionShape3D: CollisionShape3D = unit.get_node("CollisionShape3D")
		collisionShape3D.disabled = true
	else:
		var collisionShape2D: CollisionShape2D = unit.get_node("CollisionShape2D")
		collisionShape2D.disabled = true
		
	unit.unitSystemData.customVectorData = Vector3.ZERO
	unit.unitSystemData.transitionToState = "SystemPoolState"
	_freePoolUnits.append(unit)
	_activeUnits.remove_at(_activeUnits.find(unit))
	_currentUnitsCount-=1
	
	unit.set_physics_process(false)

func _spawnUnitFromPool() -> Unit:
	var unit: Unit = null

	if not multiplayer.multiplayer_peer is OfflineMultiplayerPeer && not multiplayer.is_server():
		return null
	
	if not self.visible:
		return null

	if _freePoolUnits.size() > 0:
		unit = _freePoolUnits.pop_at(0)
	else:
		unit = unitChunkPrefab.instantiate()
		
		var unitData = unit.CreateUnitData()
		
		var unitDIContainer: DIContainer = unit.diContainer

		var enemyId = _freeIdHelper.GetNextFreeId()
		
		unit.name = "Mob #" + str(enemyId)
		unit.unitData.unitName = "Mob"
		var unitNetworkData: UnitNetworkData = unitDIContainer.GetByClassType(UnitNetworkData)
		if unitNetworkData:
			unitNetworkData.UpdateUnitNetworkData(unit.unitData)
			
		unit.set_multiplayer_authority(1)
		unit.set_physics_process(false)
		
		if unit.unitSystemData:
			unit.unitSystemData.SetDied(true)
			var customVectorData
			if _spawnPositionContainer.global_position is Vector2:
				customVectorData = Vector3(_spawnPositionContainer.global_position.x, _spawnPositionContainer.global_position.y, 0)
			else:
				customVectorData = _spawnPositionContainer.global_position
			unit.unitSystemData.customVectorData = customVectorData
		
		self.add_child(unit, true)
		
	if unit.has_node("CollisionShape3D"):
		var collisionShape3D: CollisionShape3D = unit.get_node("CollisionShape3D")
		collisionShape3D.disabled = false
	else:
		var collisionShape2D: CollisionShape2D = unit.get_node("CollisionShape2D")
		collisionShape2D.disabled = false
	
		
	if unit.unitSystemData:
		unit.unitSystemData.SetDied(false)
	unit.set_physics_process(true)
		
	_disconnectAllSignalConnections(unit.onFree)
	unit.onFree.connect(func():
		_unitToPool(unit)
	)
	_activeUnits.append(unit)
	return unit
	
