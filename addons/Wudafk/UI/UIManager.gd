class_name UIManager extends Control

@export var openPopups: Array[Control] = []

var _diContainer: DIContainer
	
func InjectBeforeReady(diContainer: DIContainer):
	_diContainer = diContainer

func OpenPopup(popupPrefab: PackedScene, diContainer: DIContainer = null, isNew: bool = false):
	if not diContainer:
		diContainer = _diContainer
	var popup: Control
	if not isNew:
		for i in get_child_count():
			var child = get_child(i)
			if child.scene_file_path == popupPrefab.resource_path:
				popup = child
				popup.get_parent().remove_child(popup)
				add_child(popup)
				break
	if not popup:
		popup = popupPrefab.instantiate()
		if popup.has_method("InjectBeforeReady"):
			popup.InjectBeforeReady(diContainer)
		if popup.get_node("DIContainer"):
			popup.get_node("DIContainer").InjectBeforeReady(diContainer)
		openPopups.append(popup)
		add_child(popup)
		
	popup.visible = true
	
	return  popup
