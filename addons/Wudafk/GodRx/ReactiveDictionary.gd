class_name ReactiveDictionary
extends RefCounted

signal item_added(key: Variant, value: Variant)
signal item_updated(key: Variant, new_value: Variant, old_value: Variant)
signal item_removed(key: Variant, value: Variant)
signal cleared()

var _dictionary: Dictionary

func _init(initial_dictionary: Dictionary = {}):
	_dictionary = initial_dictionary

func add(key: Variant, value: Variant):
	var is_new_item = not _dictionary.has(key)
	var old_value: Variant = null

	if not is_new_item:
		old_value = _dictionary[key]
		if _dictionary[key] == value:
			return

	_dictionary[key] = value

	if is_new_item:
		item_added.emit(key, value)
	else:
		item_updated.emit(key, value, old_value)

func erase(key: Variant) -> bool:
	if _dictionary.has(key):
		var removed_value: Variant = _dictionary[key]
		_dictionary.erase(key)
		item_removed.emit(key, removed_value)
		return true
	return false

func clear():
	if not _dictionary.is_empty():
		_dictionary.clear()
		cleared.emit()

func Get(key, default_value: Variant = null) -> Variant:
	return _dictionary.get(key, default_value)

func has(key: Variant) -> bool:
	return _dictionary.has(key)

func keys() -> Array[Variant]:
	return _dictionary.keys()

func values() -> Array[Variant]:
	return _dictionary.values()

func size() -> int:
	return _dictionary.size()

func is_empty() -> bool:
	return _dictionary.is_empty()

func _to_string():
	return "ReactiveDictionary(%s)" % str(_dictionary)
