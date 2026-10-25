class_name Availability
extends RefCounted
## Decides which actions the player can take in a given state. Pure, no randomness.

## Whether the action can be taken in this state.
static func is_available(state : GameState, action : ActionData) -> bool:
	return action.unavailable_if_flag.is_empty() or not state.has_flag(action.unavailable_if_flag)

## Actions the player can take in this state, in data order.
static func available_actions(state : GameState, game : GameData) -> Array[ActionData]:
	var available : Array[ActionData] = []
	available.assign(game.actions.filter(func(action : ActionData) -> bool: return is_available(state, action)))
	return available
