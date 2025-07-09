#raw code
class_name SingleRollbackSynchronizer extends Node

@export var root: Node

var _is_initialized: bool = false

var _nodes: Array[Node] = []

var _gameTime: GameTime
func InjectBeforeReady(diContainer: DIContainer):
	_gameTime = diContainer.rootContainer.GetByClassType(GameTime)

## Process settings.
##
## Call this after any change to configuration. Updates based on authority too
## ( calls process_authority ).
func process_settings() -> void:
	var root_ = root.get_parent()
	# Gather all rollback-aware nodes to simulate during rollbacks
	_nodes = root_.find_children("*", "", true, false)
	_nodes.push_front(root_)
	_nodes = _nodes.filter(func(it): return _gameTime.is_rollback_aware(it))
	
	_nodes.erase(self)
	
	_is_initialized = true
	pass
	
func _connect_signals() -> void:
	_gameTime._on_process_tick.connect(_process_tick)

func _disconnect_signals() -> void:
	_gameTime._on_process_tick.disconnect(_process_tick)


func _enter_tree() -> void:
	if not multiplayer.multiplayer_peer is OfflineMultiplayerPeer:
		return
	if Engine.is_editor_hint():
		return
		
	if not root:
		root = get_parent()

	#if not NetworkTime.is_initial_sync_done():
		# Wait for time sync to complete
		#await NetworkTime.after_sync
	_connect_signals.call_deferred()
	process_settings.call_deferred()

func _exit_tree() -> void:
	if Engine.is_editor_hint():
		return

	_is_initialized = false
	_disconnect_signals()

func _process_tick(tick: int) -> void:
	# Simulate rollback tick
	#	Method call on rewindables
	#	Rollback synchronizers go through each node they manage
	#	If current tick is in node's range, tick
	#		If authority: Latest input >= tick >= Latest state
	#		If not: Latest input >= tick >= Earliest input
	for node in _nodes:
		#if not NetworkRollback.is_simulated(node):
			#continue
		#var is_fresh := _freshness_store.is_fresh(node, tick)
		var is_fresh = true
		#_is_predicted_tick = _is_predicted_tick_for(node, tick)
		_gameTime.process_rollback(node, _gameTime.ticktime, tick, is_fresh)

		#if _skipset.has(node):
			#continue

		#_freshness_store.notify_processed(node, tick)
		#_simset.add(node)
