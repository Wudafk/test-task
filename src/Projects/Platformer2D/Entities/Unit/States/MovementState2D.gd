extends BaseState2D

func InjectBeforeReady(diContainer: DIContainer):
	super.InjectBeforeReady(diContainer)
	
func tick(delta, tick, is_fresh):
	if entity.unitSystemData.transitionToState:
		TransitionTo(entity.unitSystemData.transitionToState)
		return
		
	entity.velocity.y += entity.gravity * delta * 3

	var direction = _playerInput.input_dir
	var speed = 100

	if direction:
		entity.velocity.x = direction.x * speed
		var newScale = abs(unit._unitModel.scale.x) * sign(direction.x)
		if newScale < 0 && (unit as Unit)._unitModel.scale.x > 0:
			(unit as Unit)._unitModel.scale.x = newScale
				
		elif newScale > 0 && (unit as Unit)._unitModel.scale.x < 0:
			(unit as Unit)._unitModel.scale.x = newScale
	else:
		entity.velocity.x = move_toward(entity.velocity.x, 0, speed)
		if abs(entity.velocity.x) < 5:
			TransitionTo("IdleState")
			return

	if _playerInput.jump_input:
		TransitionTo("JumpState")
		return

	if _playerInput.attack_input:
		TransitionTo("AttackState")
		return

	entity.move_and_slide()
