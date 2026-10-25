class_name ActionResolver
extends RefCounted
## Validates player actions and resolves their randomness into events. Never changes state itself.

var _game : GameData

func _init(game : GameData) -> void:
	_game = game

## Events that open a new game with the given seed.
func start(seed_value : int) -> Array[Events.Event]:
	return [
		Events.GameStarted.new(seed_value, GameRng.initial_state(seed_value)),
		Events.MessageShown.new(_game.start_message),
	]

## Events produced by the player taking the action; empty when the action is not available.
func resolve(state : GameState, action_id : StringName, rng : RandomNumberGenerator) -> Array[Events.Event]:
	var action := _game.find_action(action_id)
	assert(action != null, "Unknown action '%s'" % action_id)
	if action == null or not Availability.is_available(state, action):
		return []
	if rng.randf() < action.chance:
		return [
			Events.ActionAttempted.new(action.id, true, rng.state),
			Events.FlagSet.new(action.success_flag),
			Events.MessageShown.new(action.success_message),
		]
	var message := _pick_failure_message(action, state.message_id, rng)
	return [
		Events.ActionAttempted.new(action.id, false, rng.state),
		Events.MessageShown.new(message),
	]

## Random failure message, different from the current one when the action has more than one.
func _pick_failure_message(action : ActionData, current : StringName, rng : RandomNumberGenerator) -> StringName:
	var candidates := action.failure_messages.filter(func(id : StringName) -> bool: return id != current)
	if candidates.is_empty():
		candidates = action.failure_messages
	return candidates[rng.randi_range(0, candidates.size() - 1)]
