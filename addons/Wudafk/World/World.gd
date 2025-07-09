class_name World extends Node

@export var autoInit: bool
@export var _playerUnitsManager: iPlayerManager
@export var _playerCameraController: iCameraController
@export var _playerUnitInputController: iInputController
@export var _worldDependencyFactory: WorldDependencyFactory

@export var _diContainer: DIContainer
var diContainer: DIContainer:
	get():
		if not _diContainer:
			_diContainer = get_node("DIContainer")
		return _diContainer

func _enter_tree():
	if get_parent() is Window:
		autoInit = true
	_worldDependencyFactory.CreateDependenciesForTheWorld(diContainer)
	_diContainer.InjectBeforeReady()
	
	if not _diContainer.GetByClassType(iPlayerManager, true):
		_diContainer.Add(_playerUnitsManager)
	if not _diContainer.GetByClassType(iCameraController, true):
		_diContainer.Add(_playerCameraController)
	if not _diContainer.GetByClassType(iInputController, true):
		_diContainer.Add(_playerUnitInputController)
	
	if _playerUnitsManager:
		_playerUnitsManager.onAddedLocalHero.connect(func(localHero):
			_playerCameraController.SetFollowTarget(localHero)
			_playerUnitInputController.SetControlledCharacter(localHero)
		)

func _ready():
	AddPlayer(1, {}, {
		id= 1,
		name="Wudafk",
		data= {
			level=3,
			health=3,
			exp=33,
			coins= 3,
			statLevels={
				basic={
					strength=3,
				},
			},
		},
	})

func AddPlayer(networkId: int, queryData, responseData) -> Node:
	var world = self
	var worldDIContainer = world.diContainer
	if not _playerUnitsManager:
		return null
	var hero = _playerUnitsManager.AddHero(networkId, queryData, responseData)
	
	var singleRollbackSynchronizer = SingleRollbackSynchronizer.new()
	hero.diContainer.Add(singleRollbackSynchronizer)
	singleRollbackSynchronizer.InjectBeforeReady(hero.diContainer)
	hero.add_child(singleRollbackSynchronizer)
	hero.unitNetworkData.UpdateUnitNetworkData(hero.unitData)
	return hero
