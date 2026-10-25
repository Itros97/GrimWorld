class_name ActionData
extends RefCounted
## One player action as defined in data/game.json.

var id : StringName
var label : String
var chance : float
var unavailable_if_flag : StringName
var success_flag : StringName
var success_message : StringName
var failure_messages : Array[StringName] = []

## Builds the action from its JSON object; appends to errors every field that is wrong.
static func from(dict : Dictionary, path : String, errors : Array[String]) -> ActionData:
	var action := ActionData.new()
	action.id = JsonReader.read_string(dict, "id", path, errors)
	action.label = JsonReader.read_string(dict, "label", path, errors)
	action.chance = JsonReader.read_number(dict, "chance", path, errors, 0.0, 1.0)
	action.unavailable_if_flag = JsonReader.read_optional_string(dict, "unavailable_if_flag", path, errors)
	var success_path := JsonReader.field_path(path, "success")
	var success := JsonReader.read_dict(dict, "success", path, errors)
	action.success_flag = JsonReader.read_string(success, "flag", success_path, errors)
	action.success_message = JsonReader.read_string(success, "message", success_path, errors)
	action.failure_messages = JsonReader.read_id_array(dict, "failure_messages", path, errors)
	return action

## Every message id the action refers to, keyed by the path of the field that holds it.
func message_references(path : String) -> Dictionary[String, StringName]:
	var references : Dictionary[String, StringName] = {}
	references[JsonReader.field_path(path, "success.message")] = success_message
	for i in failure_messages.size():
		references["%s[%d]" % [JsonReader.field_path(path, "failure_messages"), i]] = failure_messages[i]
	return references
