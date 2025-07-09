extends BaseState2D

var _direction

func enter(previous_state: RewindableState, tick: int):
	if previous_state.name == "IdleState" || previous_state.name == "MovementState":
		var jump_velocity = -700
		entity.velocity.y = jump_velocity
		_direction = _playerInput.input_dir

func exit(next_state: RewindableState, tick: int):
	_direction = null
	entity.velocity.x = 0

func tick(delta, tick, is_fresh):
	if entity.unitSystemData.transitionToState:
		TransitionTo(entity.unitSystemData.transitionToState)
		return
		
	entity.velocity.y += entity.gravity * delta * 3

	var direction = _playerInput.input_dir

	entity.move_and_slide()

	if entity.is_on_floor():
		if direction:
			TransitionTo("MovementState")
		else:
			TransitionTo("IdleState")

	if _playerInput.attack_input:
		TransitionTo("AttackState")
