class_name FreeIdHelper extends Node

var _free_ids: Array[int] = []
var _next_id = 1

func GetNextFreeId():
	var id
	if _free_ids.size() > 0:
		id = _free_ids.pop_at(0)
		return id
	id = _next_id
	_next_id=_next_id+1
	return id

func DoIdFree(id: int):
	_free_ids.append(id)
