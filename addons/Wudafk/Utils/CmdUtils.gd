class_name CmdUtils

static func GetSystemArgument(argumentName: String):
	var argument
	var cmd_args = OS.get_cmdline_args()
	var index = cmd_args.find(argumentName)
	if index != -1 and index < cmd_args.size():
		argument = cmd_args[index+1]
		
	return argument
