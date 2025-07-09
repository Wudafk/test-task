class_name Hero extends Unit

func _enter_tree() -> void:
	
	var networkId = str(self.name).to_int()
	self.set_multiplayer_authority(networkId)
	super._enter_tree()
	
	var playerUnitsManager: PlayerUnitsManager = GetWorld().diContainer.GetByClassType(PlayerUnitsManager)
	playerUnitsManager.localHero = self

func _ready():
	super._ready()
	get_parent().OnAddedUnit(self)
