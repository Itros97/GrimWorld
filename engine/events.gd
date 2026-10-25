class_name Events
extends RefCounted
## Every event of the game. Events carry already-resolved results, so applying them needs no randomness.

const GAME_STARTED := &"game_started"
const ACTION_ATTEMPTED := &"action_attempted"
const FLAG_SET := &"flag_set"
const MESSAGE_SHOWN := &"message_shown"

## Every event type; StateReducer must handle all of them.
const TYPES : Array[StringName] = [GAME_STARTED, ACTION_ATTEMPTED, FLAG_SET, MESSAGE_SHOWN]

## Base of all events.
class Event extends RefCounted:
	var type : StringName

	## Plain dictionary of the event, for comparisons and future saves.
	func to_dict() -> Dictionary:
		return { "type": type }

## A new game starts with this seed; rng_state is the generator position for it.
class GameStarted extends Event:
	var seed_value : int
	var rng_state : int

	func _init(p_seed_value : int, p_rng_state : int) -> void:
		type = GAME_STARTED
		seed_value = p_seed_value
		rng_state = p_rng_state

	func to_dict() -> Dictionary:
		return { "type": type, "seed": seed_value, "rng_state": rng_state }

## An action with a random outcome was attempted; rng_state is the generator position after resolving it.
class ActionAttempted extends Event:
	var action : StringName
	var success : bool
	var rng_state : int

	func _init(p_action : StringName, p_success : bool, p_rng_state : int) -> void:
		type = ACTION_ATTEMPTED
		action = p_action
		success = p_success
		rng_state = p_rng_state

	func to_dict() -> Dictionary:
		return { "type": type, "action": action, "success": success, "rng_state": rng_state }

## A flag (clue, looted spot, lit lighter...) becomes true.
class FlagSet extends Event:
	var id : StringName

	func _init(p_id : StringName) -> void:
		type = FLAG_SET
		id = p_id

	func to_dict() -> Dictionary:
		return { "type": type, "id": id }

## The narrative text changes to the message with this id.
class MessageShown extends Event:
	var message_id : StringName

	func _init(p_message_id : StringName) -> void:
		type = MESSAGE_SHOWN
		message_id = p_message_id

	func to_dict() -> Dictionary:
		return { "type": type, "message_id": message_id }
