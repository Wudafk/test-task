class_name UnitInputController extends iInputController

var _unitInput: PlayerInput
var _unitSystemData: UnitSystemData

func SetControlledCharacter(target: Node):
	var unit: Unit = target
	_unitInput = unit.unitInputData
	_unitSystemData = unit.unitSystemData
	pass
	
func _process(delta):
	if not _unitInput:
		return
	if _unitSystemData.isDied:
		_unitInput.clear_input()
		return
	_unitInput.input_dir = Input.get_vector("left", "right", "forward", "backward")
	_unitInput.jump_input = Input.is_action_pressed("jump")
	_unitInput.run_input = Input.is_action_pressed("run")
	_unitInput.attack_input = Input.is_action_pressed("attack")
