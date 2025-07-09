class_name DIContainer
extends Node

@export var isDebug: bool
@export var _isAddToParent: bool
@export var _instances: Array[Node]

var rootContainer: DIContainer
var parentContainer: DIContainer
var ownerContainer: DIContainer
		
func InjectBeforeReady(parentDIContainer: DIContainer = null, ownerDIContainer: DIContainer = null):
	var isOwner: bool = false
	ownerContainer = ownerDIContainer
	parentContainer = parentDIContainer
	
	if ownerDIContainer == self:
		isOwner = true
	
	if not ownerContainer:
		ownerContainer = self
	
	if not parentDIContainer:
		rootContainer = self
	else:
		rootContainer = parentContainer.rootContainer
		
	for i in _instances.size():
		var instance = _instances[i]
		
		if not instance:
			continue
		if instance is DIContainer:
			
			var di: DIContainer = instance
			if di._isAddToParent:
				self.Add(di)
			di.InjectBeforeReady(self, ownerContainer)
		elif instance.has_node("DIContainer"):
			var instanceDIContainer = instance.get_node("DIContainer")
			if instanceDIContainer._isAddToParent:
				self.Add(instanceDIContainer)
			instanceDIContainer.InjectBeforeReady(self, ownerContainer)
		
		if instance.has_method("InjectBeforeReady"):
			instance.InjectBeforeReady(self)

	if isOwner:
		if get_parent().has_method("InjectBeforeReady"):
			get_parent().InjectBeforeReady(self)

func GetByNodeName(nodeName: String, isIgnoreError: bool = false) -> Node:
	for instance in _instances:
		if not is_instance_valid(instance):
			continue
		if instance.name == nodeName:
			return instance
		if instance.has_method("GetByNodeName"):
			var instanceInChild = instance.GetByNodeName(nodeName, true)
			if instanceInChild:
				return instanceInChild
		elif instance.has_node("DIContainer"):
			var instanceDIContainer = instance.get_node("DIContainer")
			var instanceInChild = instanceDIContainer.GetByNodeName(nodeName, true)
			if instanceInChild:
				return instanceInChild

	if not isIgnoreError:
		push_error("DIContainer: Объект с именем '%s' не найден в контейнере." % nodeName)
	return null

func GetByClassType(classType: GDScript, isIgnoreError: bool = false) -> Node:
	if not classType:
		printerr("DIContainer: Invalid class type passed for lookup.")
		return null

	for instance in _instances:
		if not is_instance_valid(instance):
			continue
		var className = GDScriptHelper.GetName(classType)
		if instance.get_script() == classType || instance.is_class(className) || (instance.has_method("is_inherit_class") && instance.is_inherit_class(className)):
			return instance
		
		if instance.has_method("GetByClassType"):
			var instanceInChild = instance.GetByClassType(classType, true)
			if instanceInChild:
				return instanceInChild
		elif instance.has_node("DIContainer"):
			var instanceDIContainer = instance.get_node("DIContainer")
			var instanceInChild = instanceDIContainer.GetByClassType(classType, true)
			if instanceInChild:
				return instanceInChild

	if not isIgnoreError:
		push_error("DIContainer: Объект с типом '%s' не найден в контейнере." % classType.resource_path)
	return null

func _get(property) -> Variant:
	return GetByNodeName(property)

func Add(instance) -> Variant:
	if _instances.has(instance):
		printerr("No need this call.")
		
	_instances.append(instance)
	return instance
	
