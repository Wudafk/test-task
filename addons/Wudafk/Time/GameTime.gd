#raw code
class_name GameTime extends Node

var _networkTime: _NetworkTime

func InjectBeforeReady(diContainer: DIContainer):
	_networkTime = NetworkTime

var SingltTime: _SingleTime

@export_enum("Single", "Network") 
var timeType: int = 1
			
var time: Node

var _process_delta: float = 0

###
signal on_tick(delta: float, tick: int)
signal before_tick_loop
signal after_tick_loop
signal _on_process_tick(tick: int)

var tick: int:
	get:
		return time.tick

func Use(time_):
	time = time_

	time.before_tick_loop.connect(func():
		before_tick_loop.emit()
	)
	time.after_tick_loop.connect(func():
		after_tick_loop.emit()
	)
	time.on_tick.connect(func(delta, tick):
		on_tick.emit(delta, tick)
	)
	

func Create(timeClass: GDScript):
	time = timeClass.new()
	add_child(time)
	time.before_tick_loop.connect(func():
		before_tick_loop.emit()
	)
	time.after_tick_loop.connect(func():
		after_tick_loop.emit()
	)

func _ready():
	match timeType:
		0:
			var time = _SingleTime.new()
			add_child(time)
			Use(time)
			time.on_process_tick.connect(func(tick):
				_on_process_tick.emit(tick)
			)
		1:
			Use(NetworkTime)
		_:
			pass

var sync_to_physics: bool:
	get:
		return time._sync_to_physics
	set(v):
		time._sync_to_physics = v

var ticktime: float:
	get:
		return time.ticktime
	set(v):
		time.ticktime = v

var tickrate: int:
	get:
		return time.tickrate
	set(v):
		time.tickrate = v

func is_rollback_aware(what: Object) -> bool:
	if time.has_method("is_rollback_aware"):
		return time.is_rollback_aware(what)
		
	return false

func process_rollback(target: Object, delta: float, p_tick: int, is_fresh: bool) -> void:
	time.process_rollback(target, delta, p_tick, is_fresh)

####

func _process(delta: float) -> void:
	_process_delta = delta

var physics_factor: float:
	get:
		if Engine.is_in_physics_frame():
			return Engine.physics_ticks_per_second / tickrate
		else:
			return ticktime / _process_delta
	set(v):
		push_error("Trying to set read-only variable physics_factor")
