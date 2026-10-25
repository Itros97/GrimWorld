extends TestCase
## Behaviour 6 of the phase 1 spec and the purity of the reducer.

func test_fold_of_the_event_log_equals_the_stepwise_state() -> void:
	var resolver := ActionResolver.new(Fixtures.game())
	var event_log : Array[Events.Event] = resolver.start(Fixtures.SEED)
	var state := StateReducer.fold(GameState.new(), event_log)
	for i in 10:
		var step := resolver.resolve(state, Fixtures.ACTION_ID, GameRng.from_state(state))
		event_log.append_array(step)
		state = StateReducer.fold(state, step)
	assert_eq(StateReducer.fold(GameState.new(), event_log).to_dict(), state.to_dict(), "folded state")

func test_apply_never_mutates_its_input() -> void:
	var state := GameState.new()
	var snapshot := state.to_dict()
	for event in _one_event_of_each_type():
		StateReducer.apply(state, event)
	assert_eq(state.to_dict(), snapshot, "input state")

func test_reducer_handles_every_event_type() -> void:
	var events := _one_event_of_each_type()
	var types := events.map(func(event : Events.Event) -> StringName: return event.type)
	assert_eq(types, Events.TYPES, "a sample for each event type")
	for event in events:
		assert_true(StateReducer.apply(GameState.new(), event) != null, "%s is handled" % event.type)

func test_action_attempted_counts_the_attempt_and_moves_the_rng() -> void:
	var state := StateReducer.apply(GameState.new(), Events.ActionAttempted.new(&"light_lighter", false, 99))
	assert_eq(state.attempts_of(&"light_lighter"), 1, "attempts")
	assert_eq(state.rng_state, 99, "rng state")

## One sample event per type, in the order of Events.TYPES.
func _one_event_of_each_type() -> Array[Events.Event]:
	return [
		Events.GameStarted.new(1, 2),
		Events.ActionAttempted.new(&"light_lighter", true, 3),
		Events.FlagSet.new(&"lighter_lit"),
		Events.MessageShown.new(&"dark"),
	]
