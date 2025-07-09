class_name EnemyBotAI2D extends Node

@export var _followTargetArea: Area2D

var _unit: Unit
var _unitInput: PlayerInput
var _gameTime: GameTime
var _arcDamageAreaData: ArcDamageAreaData

var patrolSide: int = 1
var attackEverySeconds: float = 3.0
var lastAttackTime: float

var _followTarget: Unit
var _potentialTargets: Array[Unit] = []

func InjectBeforeReady(diContainer: DIContainer):
	_unit = diContainer.ownerContainer.get_parent()
	_unitInput = diContainer.ownerContainer.GetByClassType(PlayerInput)
	_gameTime = diContainer.rootContainer.GetByClassType(GameTime)
	_arcDamageAreaData = diContainer.ownerContainer.GetByClassType(ArcDamageAreaData)
	
	_gameTime.on_tick.connect(_gather)
	
func _enter_tree():
	_followTargetArea.body_entered.connect(_onBodyEntered)
	_followTargetArea.body_exited.connect(_onBodyExited)

func _gather(delta, tick):
	var dirToTarget: Vector2
	if _followTarget:
		dirToTarget = _followTarget.global_position - _unit.global_position
		if dirToTarget.x < 0 && patrolSide > 0:
			patrolSide = -1
		elif dirToTarget.x > 0 && patrolSide < 0:
			patrolSide = 1
	
	if _unitInput.input_dir.x && not is_ground_ahead_manual(_unitInput.input_dir.x):
		patrolSide = -1 * patrolSide
	
	if patrolSide:
		_unitInput.input_dir = Vector2(patrolSide, 0)
	
	_unitInput.attack_input = _followTarget && _arcDamageAreaData.arcData.arcRadius > dirToTarget.length()
	pass

func _exit_tree():
	if _gameTime.on_tick.is_connected(_gather):
		_gameTime.on_tick.disconnect(_gather)

func _onBodyEntered(body):
	if body == _unit:
		return
	if not body is Unit:
		return
	_potentialTargets.append(body)
	
	if not _followTarget:
		_followTarget = body
		
func _onBodyExited(body):
	if body == _unit:
		return
	if not body is Unit:
		return
	_potentialTargets.remove_at(_potentialTargets.find(body))
	
	if _followTarget == body:
		_followTarget = null
		if _potentialTargets.size() > 0:
			_followTarget = _potentialTargets[0]
	
@export var ray_cast_distance_forward: float = 10.0
@export var ray_cast_distance_down: float = 20.0

func is_ground_ahead_manual(direction: int) -> bool:
	var space_state = _unit.get_world_2d().direct_space_state
	var start_point = _unit.global_position + Vector2(ray_cast_distance_forward * direction, 0)
	var end_point = start_point + Vector2(0, ray_cast_distance_down)
	var query = PhysicsRayQueryParameters2D.new()
	query.from = start_point
	query.to = end_point
	query.collision_mask = 1 << 15
	query.collide_with_bodies = true
	query.collide_with_areas = false
	query.exclude = [self] 
	var result = space_state.intersect_ray(query)
	return result.size() > 0
