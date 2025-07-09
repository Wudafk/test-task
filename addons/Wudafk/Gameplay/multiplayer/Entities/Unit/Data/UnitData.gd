class_name UnitData extends Node

@export var unitName: String
@export var level: int

@export var health: float
@export var mana: float

@export var maxHealth: int

func CopyFrom(from: UnitData):
	unitName = from.unitName
	level = from.level
	health = from.health

func _to_string() -> String:
	return "EntityData: name=%s" % name

func GetMaxHealth():
	return 100 + (level * 10)

func SetHealth(value: float):
	health = value
	
func ChangeHealth(value: float):
	health -= value

func UpdateMaxHealth():
	maxHealth = GetMaxHealth()

func Update():
	UpdateMaxHealth()
