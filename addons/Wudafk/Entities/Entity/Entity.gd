class_name Entity extends Node

signal onFree()

var _diContainer: DIContainer
var diContainer: DIContainer:
	get():
		if not _diContainer:
			_diContainer = get_node("DIContainer")
		return _diContainer

var _unitNetworkData: UnitNetworkData
var unitNetworkData: UnitNetworkData:
	get():
		return _unitNetworkData

var body:
	get():
		var self_ = self
		if self_ is CharacterBody3D:
			return self_ as CharacterBody3D
		return self_ as CharacterBody2D

static var _entitiesDictionary: Dictionary[int, Unit] = {}
static var _uniqueEntityFreeIdHelper: FreeIdHelper = FreeIdHelper.new()
static func GetEntityByUniqueId(uniqueEntityId: int):
	return _entitiesDictionary[uniqueEntityId]
	
@export var _uniqueEntityId: int
var uniqueEntityId: int:
	get():
		return _uniqueEntityId

func _enter_tree():
	_uniqueEntityId = _uniqueEntityFreeIdHelper.GetNextFreeId()
	_entitiesDictionary[_uniqueEntityId] = self

func InjectBeforeReady(diContainer: DIContainer):
	_diContainer = diContainer
	_unitNetworkData = diContainer.ownerContainer.GetByClassType(UnitNetworkData)
		
func GetWorld() -> World:
	return GET_WORLD(self)
		
static func GET_WORLD(node: Node) -> World:
	var worldRoot = node.get_viewport()
	if worldRoot is Window:
		var parent = node.get_parent()
		while not parent is World:
			parent = parent.get_parent()
			
		if parent is World:
			return parent
	else:
		return worldRoot.get_child(0) as World
	return null
