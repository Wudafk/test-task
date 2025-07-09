class_name WorldDependencyFactory extends Node

func CreateDependenciesForTheWorld(diContainer: DIContainer):
	add_child(diContainer.Add(CreateGameTime()))
		
func CreateGameTime() -> GameTime:
	var gameTime = GameTime.new()
	var timeType = 1
	var windowIdArg = CmdUtils.GetSystemArgument("--window-id")
	if not windowIdArg:
		timeType = 0
	gameTime.timeType = timeType
	return gameTime
