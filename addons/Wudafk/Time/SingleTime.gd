#raw code
class_name _SingleTime extends Node

signal on_tick(delta: float, tick: int)
signal before_tick_loop
signal after_tick_loop
signal on_process_tick(tick: int)

var tick: int

var _physics_frames_counter: int = 0
const TARGET_TICKS_PER_SECOND = 30 # Предполагаем, что Rollback Netcode работает на 30 FPS
const PHYSICS_FPS = 60 # По умолчанию Physics FPS в Godot

var _tickrate: int = ProjectSettings.get_setting(&"netfox/time/tickrate", 30)
var _sync_to_physics: bool = ProjectSettings.get_setting(&"netfox/time/sync_to_physics", false)

var summarDeltaForTick: float = 0

## [i]read-only[/i], you can change this in the project settings
var sync_to_physics: bool:
	get:
		return _sync_to_physics
	set(v):
		push_error("Trying to set read-only variable sync_to_physics")

var ticktime: float:
	get:
		return 1.0 / tickrate
	set(v):
		push_error("Trying to set read-only variable ticktime")

var tickrate: int:
	get:
		if sync_to_physics:
			return Engine.physics_ticks_per_second
		else:
			return _tickrate
	set(v):
		push_error("Trying to set read-only variable tickrate")

func _physics_process(delta: float):
	_physics_frames_counter += 1
	summarDeltaForTick += delta

	if _physics_frames_counter * tickrate >= PHYSICS_FPS:
		tick += 1
		before_tick_loop.emit()
		on_process_tick.emit(tick)
		on_tick.emit(summarDeltaForTick, tick)
		summarDeltaForTick = 0
		after_tick_loop.emit()
		_physics_frames_counter = 0

	#if tick % 30 == 0:
		#print("SingleTime: Tick #%d" % tick)

func is_rollback_aware(what: Object) -> bool:
	return what.has_method(&"_rollback_tick")

## Calls the [code]_rollback_tick[/code] method on the target, running its
## simulation for the given rollback tick.
## [br][br]
## This is used by [RollbackSynchronizer] to resimulate ticks during rollback.
## While the [code]_rollback_tick[/code] method could be called directly as
## well, this method exists to future-proof the code a bit, so the method name
## is not repeated all over the place.
## [br][br]
## [i]Note:[/i] Make sure to check if the target is rollback-aware, because if
## it's not, this method will run into an error.
func process_rollback(target: Object, delta: float, p_tick: int, is_fresh: bool) -> void:
	target._rollback_tick(delta, p_tick, is_fresh)
