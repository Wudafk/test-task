extends BaseState2D

func enter(previous_state: RewindableState, tick: int):
	entity.velocity = Vector2.ZERO

func tick(delta, tick, is_fresh):
	entity.velocity.y += entity.gravity * delta * 3

	if entity.unitSystemData.transitionToState:
		TransitionTo(entity.unitSystemData.transitionToState)
		return
		
	var direction = _playerInput.input_dir
	if direction:
		TransitionTo("MovementState")
	
	if _playerInput.jump_input:
		TransitionTo("JumpState")
	
	if _playerInput.attack_input:
		TransitionTo("AttackState")

	entity.move_and_slide()
