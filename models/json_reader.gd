class_name JsonReader
extends RefCounted
## Reads typed fields from parsed JSON; every wrong field appends an error naming its path.

## Root object of the JSON text; appends an error and returns an empty one when it is not valid.
static func parse_object(json_text : String, errors : Array[String]) -> Dictionary:
	var json := JSON.new()
	if json.parse(json_text) != OK:
		errors.append("line %d: %s" % [json.get_error_line(), json.get_error_message()])
		return {}
	if not json.data is Dictionary:
		errors.append("root: expected an object")
		return {}
	return json.data

## Path of a field inside its parent, e.g. "actions[0].chance".
static func field_path(path : String, key : String) -> String:
	return key if path.is_empty() else "%s.%s" % [path, key]

## Non-empty string field.
static func read_string(dict : Dictionary, key : String, path : String, errors : Array[String]) -> String:
	var value : Variant = dict.get(key)
	if value is String and not value.is_empty():
		return value
	errors.append("%s: expected a non-empty string, got %s" % [field_path(path, key), value])
	return ""

## String field that may be missing; empty when it is.
static func read_optional_string(dict : Dictionary, key : String, path : String, errors : Array[String]) -> String:
	return read_string(dict, key, path, errors) if dict.has(key) else ""

## Number field between min_value and max_value, both included.
static func read_number(dict : Dictionary, key : String, path : String, errors : Array[String], min_value : float, max_value : float) -> float:
	var value : Variant = dict.get(key)
	if (value is float or value is int) and value >= min_value and value <= max_value:
		return value
	errors.append("%s: expected a number between %s and %s, got %s" % [field_path(path, key), min_value, max_value, value])
	return min_value

## Object field.
static func read_dict(dict : Dictionary, key : String, path : String, errors : Array[String]) -> Dictionary:
	var value : Variant = dict.get(key)
	if value is Dictionary:
		return value
	errors.append("%s: expected an object, got %s" % [field_path(path, key), value])
	return {}

## Non-empty array field whose items are all objects.
static func read_dict_array(dict : Dictionary, key : String, path : String, errors : Array[String]) -> Array[Dictionary]:
	var items : Array[Dictionary] = []
	var value : Variant = dict.get(key)
	if not value is Array or value.is_empty() or not value.all(func(item : Variant) -> bool: return item is Dictionary):
		errors.append("%s: expected a non-empty array of objects, got %s" % [field_path(path, key), value])
		return items
	items.assign(value)
	return items

## Non-empty array field whose items are all non-empty strings.
static func read_id_array(dict : Dictionary, key : String, path : String, errors : Array[String]) -> Array[StringName]:
	var ids : Array[StringName] = []
	var value : Variant = dict.get(key)
	if not value is Array or value.is_empty() or not value.all(func(item : Variant) -> bool: return item is String and not item.is_empty()):
		errors.append("%s: expected a non-empty array of ids, got %s" % [field_path(path, key), value])
		return ids
	ids.assign(value.map(func(item : String) -> StringName: return StringName(item)))
	return ids
