extends BaseState2D

@export var attack_duration: float = 0.2
var timer: Timer

var _unitDamageDealer: UnitDamageDealer
var _arcDamageAreaData: ArcDamageAreaData

var isAttackEnded = false

func InjectBeforeReady(diContainer: DIContainer):
	super.InjectBeforeReady(diContainer)
	_unitDamageDealer = diContainer.ownerContainer.GetByClassType(UnitDamageDealer)
	_arcDamageAreaData = diContainer.ownerContainer.GetByClassType(ArcDamageAreaData)

func _ready():
	timer = Timer.new()
	add_child(timer)
	timer.timeout.connect(_on_attack_timer_timeout)

func enter(previous_state: RewindableState, tick: int):
	entity.velocity.x = 0
	timer.start(attack_duration)

func tick(delta, tick, is_fresh):
	if entity.unitSystemData.transitionToState:
		TransitionTo(entity.unitSystemData.transitionToState)
		return
	entity.velocity.y += entity.gravity * delta * 3
	entity.move_and_slide()
	
	if isAttackEnded:
		isAttackEnded = false
		var results = AttackAreaChecker2D.CheckArcCollision2(_arcDamageAreaData,
				1,
				[unit._unitModel]
			)
			
		for result in results:
			var collider = result.collider
			_unitDamageDealer.DealDamage(collider, 30)
		if entity.is_on_floor():
			var direction = _playerInput.input_dir
			if direction:
				TransitionTo("MovementState")
			else:
				TransitionTo("IdleState")
		else:
			TransitionTo("JumpState")
		

func _on_attack_timer_timeout():
	isAttackEnded = true
	timer.stop()
