class_name PlayerKillCounter extends Node

var killsCount: int = 0

func AddKills(count: int) -> void:
	killsCount += count
