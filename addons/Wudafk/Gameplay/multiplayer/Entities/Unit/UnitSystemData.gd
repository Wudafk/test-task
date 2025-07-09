class_name UnitSystemData extends Node

@export var customVectorData: Vector3
@export var transitionToState: String
@export var teleportRequestedThisTick: bool
@export var isDied: bool

@export var deathStartServerTime: float = 0
@export var respawnInSeconds: float = 0

func SetDied(value: bool):
	isDied = value

func seconds_left_until_respawn() -> float:
	if not isDied:
		return 0.0
	
	var current_client_time = Time.get_ticks_msec() / 1000.0
	var time_since_death_on_client = current_client_time - deathStartServerTime
	var remaining_time = respawnInSeconds - time_since_death_on_client
	return max(0.0, remaining_time)
