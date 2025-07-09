class_name Unit extends Entity

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var unitInputData: PlayerInput
var _unitInputData: PlayerInput
var _unitModel: Node
var _unitUI: Node
var _gameTime: GameTime

var unitData: UnitData
var _unitSystemData: UnitSystemData
var unitSystemData: UnitSystemData:
	get():
		if not _unitSystemData:
			_unitSystemData = diContainer.GetByNodeName("UnitSystemData")
		return _unitSystemData
		
var _unitDamageTaker: UnitDamageTaker
var unitDamageTaker: UnitDamageTaker:
	get():
		return _unitDamageTaker

func InjectBeforeReady(diContainer: DIContainer):
	if body is Node2D:
		gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
	super.InjectBeforeReady(diContainer)
	unitInputData = diContainer.GetByNodeName("UnitInputData")
	_unitInputData = diContainer.GetByNodeName("UnitInputData")
	_unitDamageTaker = diContainer.GetByNodeName("UnitDamageTaker")
	_unitSystemData = diContainer.GetByNodeName("UnitSystemData")
	_unitModel = diContainer.GetByNodeName("UnitModel")
	_unitUI = diContainer.GetByNodeName("UnitUI")
	_gameTime = diContainer.rootContainer.GetByClassType(GameTime)

func _enter_tree() -> void:
	super._enter_tree()
	
	diContainer.InjectBeforeReady(GetWorld().diContainer, diContainer)
	
	if self.has_node("CollisionShape3D"):
		var collisionShape3D: CollisionShape3D = self.get_node("CollisionShape3D")
		collisionShape3D.disabled = true
	
	if self.has_node("CollisionShape2D"):
		var collisionShape2D: CollisionShape2D = self.get_node("CollisionShape2D")
		collisionShape2D.disabled = true
	
	if self._unitModel:
		self._unitModel.visible = false
	if _unitUI:
		self._unitUI.visible = false

func CreateUnitData() -> UnitData:
	unitData = UnitData.new()
	unitData.level = 1
	unitData.health = unitData.GetMaxHealth()
	diContainer.Add(unitData)
	return unitData

func _ready():
	var rewindableStateMachine: RewindableStateMachine = diContainer.GetByNodeName("RewindableStateMachine")
	if rewindableStateMachine:
		rewindableStateMachine.on_display_state_changed.connect(_on_display_state_changed)
		if not unitSystemData.teleportRequestedThisTick:
			unitSystemData.teleportRequestedThisTick = true
			var customVectorData = Vector3()
			if self.body.global_position is Vector2:
				customVectorData.x = self.body.global_position.x
				customVectorData.y = self.body.global_position.y
			else:
				customVectorData = self.body.global_position
			unitSystemData.customVectorData = customVectorData
		rewindableStateMachine.transition("TeleportState")

func _rollback_tick(delta: float, tick: int, is_fresh: bool) -> void:
	_force_update_is_on_floor()
	if not self.body.is_on_floor():
		apply_gravity(delta)
		
func apply_gravity(delta):
	self.body.velocity.y -= gravity * delta
				
func _force_update_is_on_floor():
	var old_velocity = self.body.velocity
	self.body.velocity *= 0
	self.body.move_and_slide()
	self.body.velocity = old_velocity

func _on_display_state_changed(old_state, new_state):
	await _gameTime.after_tick_loop
	var visible = (new_state.name != "SystemPoolState") && (new_state.name != "TeleportState")
	_unitModel.visible = visible
	if _unitUI:
		_unitUI.visible = visible
	
	
	if self.has_node("CollisionShape3D"):
		var collisionShape3D: CollisionShape3D = self.get_node("CollisionShape3D")
		collisionShape3D.disabled = !visible
	else:
		var collisionShape2D: CollisionShape2D = self.get_node("CollisionShape2D")
		collisionShape2D.disabled = !visible
