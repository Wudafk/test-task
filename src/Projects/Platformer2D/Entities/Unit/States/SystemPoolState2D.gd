extends BaseState2D
	
var next = false

var addvec: Vector3

var enter_tick

func enter(previous_state: RewindableState, tick: int):
	unit._unitModel.visible = false

	unit.set_physics_process(false)
	if unit.velocity is Vector2:
		unit.velocity = Vector2.ZERO
	else:
		unit.velocity = Vector3.ZERO
	
var wait: int = 0

func tick(delta, tick, is_fresh):
	entity.unitSystemData.transitionToState = ""
	
	var global_position
	if unit.global_position is Vector2:
		global_position = Vector2(unit.unitSystemData.customVectorData.x, unit.unitSystemData.customVectorData.y)
	else:
		global_position = unit.unitSystemData.customVectorData
	unit.global_position = global_position

	if unit.velocity is Vector2:
		unit.velocity = Vector2.ZERO
	else:
		unit.velocity = Vector3.ZERO
	unit._unitModel.visible = false
	if unit.unitSystemData.teleportRequestedThisTick:
		state_machine.transition(&"TeleportState")
			
