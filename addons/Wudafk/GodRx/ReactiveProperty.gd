class_name ReactiveProperty
extends RefCounted

signal value_changed(new_value, old_value)

var _value: Variant

var value: Variant:
	get:
		return _value
	set(new_value):
		if _value != new_value:
			var old_value = _value
			_value = new_value

			value_changed.emit(_value, old_value)

func _init(initial_value: Variant = null):
	_value = initial_value

func subscribe(callable_function: Callable):
	callable_function.call(value)

	value_changed.connect(func(new_val, old_val):
		callable_function.call(new_val)
	, CONNECT_DEFERRED)

func subscribe_with_previous(callable_function: Callable):
	callable_function.call(value, null)
	value_changed.connect(callable_function, CONNECT_DEFERRED)

func unsubscribe(callable_function: Callable):
	if value_changed.is_connected(callable_function):
		value_changed.disconnect(callable_function)

func _to_string():
	return "ReactiveProperty(value: %s)" % str(_value)
