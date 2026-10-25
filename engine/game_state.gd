class_name GameState
extends RefCounted
## Snapshot of the game. Treated as immutable: only StateReducer builds new ones, from copies.

var rng_seed : int = 0
var rng_state : int = 0
var flags : Dictionary[StringName, bool] = {}
var attempts : Dictionary[StringName, int] = {}
var message_id : StringName = &""

## Deep copy, so reducers never touch the state they receive.
func copy() -> GameState:
	var next := GameState.new()
	next.rng_seed = rng_seed
	next.rng_state = rng_state
	next.flags = flags.duplicate()
	next.attempts = attempts.duplicate()
	next.message_id = message_id
	return next

## Whether the flag has been set.
func has_flag(id : StringName) -> bool:
	return flags.get(id, false)

## How many times the action has been attempted.
func attempts_of(action_id : StringName) -> int:
	return attempts.get(action_id, 0)

## Plain dictionary of every field, for comparisons and debugging.
func to_dict() -> Dictionary:
	return {
		"rng_seed": rng_seed,
		"rng_state": rng_state,
		"flags": flags.duplicate(),
		"attempts": attempts.duplicate(),
		"message_id": message_id,
	}
