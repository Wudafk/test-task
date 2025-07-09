class_name UnitNetworkData extends Node

@export var unitName: String
@export var level: int

@export var healthProgress: float
@export var manaProgress: float

func UpdateUnitNetworkData(unitData: UnitData):
	self.set_multiplayer_authority(1)
	UpdateGameplayName(unitData)
	UpdateGameplayLevel(unitData)
	UpdateGameplayHealthProgress(unitData)
	
	UpdateGameplayName(unitData)
	UpdateGameplayLevel(unitData)
	UpdateGameplayHealthProgress(unitData)

func UpdateGameplayName(unitData: UnitData):
	self.unitName = unitData.unitName

func UpdateGameplayLevel(unitData: UnitData):
	self.level = unitData.level
	
func UpdateGameplayHealthProgress(unitData: UnitData):
	self.healthProgress = unitData.health / unitData.GetMaxHealth()
	
