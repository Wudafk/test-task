class_name PlayerUnitsManager extends iPlayerManager

@export_category("Unit")
@export var _unitPrefab: PackedScene

var _heroesDataContainer: Node

var _playerInGameDictionaryRaw: Dictionary[int, Unit] = {}
var playersInGame: ReactiveDictionary = ReactiveDictionary.new(_playerInGameDictionaryRaw)

var _multiplayerSpawner

var localHero

func OnAddedUnit(unit: Unit):
	var hero: Hero = unit
	if hero.name.to_int() == 1:
		onAddedLocalHero.emit(hero)
	
func _enter_tree():
	if has_node("MultiplayerSpawner"):
		_multiplayerSpawner = get_node("MultiplayerSpawner")
	else:
		_multiplayerSpawner = MultiplayerSpawner.new()
		_multiplayerSpawner.name = "MultiplayerSpawner"
		_multiplayerSpawner.spawn_path = "../"
		add_child(_multiplayerSpawner)
		
	_multiplayerSpawner.add_spawnable_scene(_unitPrefab.resource_path)
	
	if not _heroesDataContainer:
		_heroesDataContainer = Node.new()
		_heroesDataContainer.name = "HeroesDataContainer"
		add_child(_heroesDataContainer)

func GetHeroByNetworkId(networkId: int) -> Hero:
	if _playerInGameDictionaryRaw.has(networkId):
		return _playerInGameDictionaryRaw[networkId]
	return null

func AddHero(networkId: int, queryData: Dictionary = {}, userDataJson: Dictionary = {}):
	if not playersInGame.has(networkId):
		var unit: Unit = _unitPrefab.instantiate()
		
		unit.name = str(networkId)
		setupHeroData(unit, userDataJson)
		playersInGame.add(networkId, unit)
		
		var randomQuadPosition = getRandomQuadPosition2D(1)
		var spawnPosition = randomQuadPosition + self.global_position
		
		unit.unitSystemData.teleportRequestedThisTick = true
		unit.unitSystemData.customVectorData = Vector3(spawnPosition.x, spawnPosition.y, 0)
		
		self.add_child(unit)
		return unit
	return null

func RemoveHero(networkId: int):
	if is_multiplayer_authority():
		if playersInGame.has(networkId):
			var player_to_remove = playersInGame.Get(networkId)
			player_to_remove.unitSystemData.SetDied(true)
			player_to_remove.unitData.get_parent().remove_child(player_to_remove.unitData)
			player_to_remove.heroData.get_parent().remove_child(player_to_remove.heroData)
			player_to_remove.unitData.free()
			player_to_remove.heroData.free()
			if player_to_remove:
				player_to_remove.queue_free()
			playersInGame.erase(networkId)
			return player_to_remove
	return null

func setupHeroData(hero: Hero, heroDataJson: Dictionary):
	var unitData = hero.CreateUnitData()
	_heroesDataContainer.add_child(unitData)
	
	hero.unitData.unitName = "Wudafk"
	hero.unitData.level = 1
	hero.unitData.health = hero.unitData.GetMaxHealth()
	
	var unitNetworkData = hero.diContainer.GetByNodeName("UnitNetworkData")
	unitNetworkData.UpdateUnitNetworkData(hero.unitData)

func randf_range(min_value: float, max_value: float) -> float:
	return randf() * (max_value - min_value) + min_value
func getRandomQuadPosition(spawnRadius: float = 1) -> Vector3:
	var spwn_rad = spawnRadius
	return Vector3(randf_range(-spwn_rad, spwn_rad), 0, randf_range(-spwn_rad, spwn_rad))
	
func getRandomQuadPosition2D(spawnRadius: float = 1) -> Vector2:
	var spwn_rad = spawnRadius
	return Vector2(randf_range(-spwn_rad, spwn_rad), randf_range(-spwn_rad, spwn_rad))
	
