class_name GDScriptHelper extends Node

static func GetName(classType):
	var path: String = classType.resource_path
	var pathSplit = path.split("/")
	var fileName: String = pathSplit[pathSplit.size()-1]
	var fileNameSplit = fileName.split(".")
	fileNameSplit.remove_at(fileNameSplit.size()-1)
	var scriptName = ".".join(fileNameSplit)
	return scriptName
