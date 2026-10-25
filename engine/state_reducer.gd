class_name StateReducer
extends RefCounted
## Pure functions that turn events into state: state = fold(initial_state, events). Never uses randomness.

## New state after applying one event; the input state is left untouched.
static func apply(state : GameState, event : Events.Event) -> GameState:
	var next := state.copy()
	match event.type:
		Events.GAME_STARTED:
			var started := event as Events.GameStarted
			next.rng_seed = started.seed_value
			next.rng_state = started.rng_state
		Events.ACTION_ATTEMPTED:
			var attempted := event as Events.ActionAttempted
			next.rng_state = attempted.rng_state
			next.attempts[attempted.action] = next.attempts_of(attempted.action) + 1
		Events.FLAG_SET:
			next.flags[(event as Events.FlagSet).id] = true
		Events.MESSAGE_SHOWN:
			next.message_id = (event as Events.MessageShown).message_id
		_:
			assert(false, "StateReducer does not handle event type '%s'" % event.type)
	return next

## State after applying every event in order.
static func fold(state : GameState, events : Array[Events.Event]) -> GameState:
	var current := state
	for event in events:
		current = apply(current, event)
	return current
