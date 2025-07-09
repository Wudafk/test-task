extends BaseState2D

func enter(previous_state: RewindableState, tick: int):
	var customVectorData = entity.unitSystemData.customVectorData
	unit.global_position = Vector2(customVectorData.x, customVectorData.y)

func tick(delta, tick, is_fresh):
	unit.unitSystemData.teleportRequestedThisTick = false
	unit.unitSystemData.customVectorData = Vector3.ZERO
	unit.set_physics_process(true)

	unit.unitSystemData.SetDied(false)
	
	state_machine.transition(&"IdleState")
	
