class_name GameData
extends RefCounted
## Game content loaded from data/game.json: texts and actions. Validated on load.

var start_message : StringName
var messages : Dictionary[StringName, String] = {}
var actions : Array[ActionData] = []

## Parses and validates the JSON text; the result holds every error found, with its field path.
static func parse(json_text : String) -> LoadResult:
	var errors : Array[String] = []
	var dict := JsonReader.parse_object(json_text, errors)
	if not errors.is_empty():
		return LoadResult.new(null, errors)
	return LoadResult.new(from(dict, errors), errors)

## Builds the game from its root JSON object; appends to errors every field that is wrong.
static func from(dict : Dictionary, errors : Array[String]) -> GameData:
	var game := GameData.new()
	var texts := JsonReader.read_dict(dict, "messages", "", errors)
	for key in texts:
		game.messages[StringName(key)] = JsonReader.read_string(texts, key, "messages", errors)
	game.start_message = JsonReader.read_string(dict, "start_message", "", errors)
	var items := JsonReader.read_dict_array(dict, "actions", "", errors)
	for i in items.size():
		var path := "actions[%d]" % i
		var action := ActionData.from(items[i], path, errors)
		if game.find_action(action.id) != null:
			errors.append("%s.id: duplicate action id '%s'" % [path, action.id])
		game.actions.append(action)
	game._check_message_references(errors)
	return game

## The action with this id, or null when there is none.
func find_action(id : StringName) -> ActionData:
	for action in actions:
		if action.id == id:
			return action
	return null

## Text of the message with this id; fails loud when the id is unknown.
func message(id : StringName) -> String:
	assert(messages.has(id), "Unknown message '%s'" % id)
	return messages.get(id, "")

## Appends an error for every message id that is not defined in messages.
func _check_message_references(errors : Array[String]) -> void:
	var references : Dictionary[String, StringName] = { "start_message": start_message }
	for i in actions.size():
		references.merge(actions[i].message_references("actions[%d]" % i))
	for path in references:
		var id := references[path]
		if not id.is_empty() and not messages.has(id):
			errors.append("%s: unknown message '%s'" % [path, id])
