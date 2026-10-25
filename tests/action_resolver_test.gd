extends TestCase
## Behaviours 1-5 of the phase 1 spec: starting in the dark and lighting the lighter.

func test_starts_in_the_dark_with_only_the_lighter_available() -> void:
	var game := Fixtures.game()
	var state := Fixtures.started_state(ActionResolver.new(game))
	assert_eq(state.message_id, &"dark", "start message")
	assert_eq(state.rng_seed, Fixtures.SEED, "seed")
	var ids := Availability.available_actions(state, game).map(func(action : ActionData) -> StringName: return action.id)
	assert_eq(ids, [Fixtures.ACTION_ID], "available actions")

func test_success_emits_attempt_flag_and_message() -> void:
	var resolver := ActionResolver.new(Fixtures.game(1.0))
	var state := Fixtures.started_state(resolver)
	var events := resolver.resolve(state, Fixtures.ACTION_ID, GameRng.from_state(state))
	assert_eq(_types(events), [Events.ACTION_ATTEMPTED, Events.FLAG_SET, Events.MESSAGE_SHOWN], "event types")
	assert_true((events[0] as Events.ActionAttempted).success, "attempt is a success")
	var next := StateReducer.fold(state, events)
	assert_true(next.has_flag(&"lighter_lit"), "lighter_lit flag is set")
	assert_eq(next.message_id, &"lit", "success message")

func test_lit_lighter_is_no_longer_available() -> void:
	var game := Fixtures.game(1.0)
	var resolver := ActionResolver.new(game)
	var state := Fixtures.started_state(resolver)
	state = StateReducer.fold(state, resolver.resolve(state, Fixtures.ACTION_ID, GameRng.from_state(state)))
	assert_true(Availability.available_actions(state, game).is_empty(), "no actions left")

func test_failure_emits_attempt_and_message() -> void:
	var resolver := ActionResolver.new(Fixtures.game(0.0))
	var state := Fixtures.started_state(resolver)
	var events := resolver.resolve(state, Fixtures.ACTION_ID, GameRng.from_state(state))
	assert_eq(_types(events), [Events.ACTION_ATTEMPTED, Events.MESSAGE_SHOWN], "event types")
	assert_true(not (events[0] as Events.ActionAttempted).success, "attempt is a failure")

func test_failure_only_changes_rng_attempts_and_message() -> void:
	var resolver := ActionResolver.new(Fixtures.game(0.0))
	var before := Fixtures.started_state(resolver)
	var after := StateReducer.fold(before, resolver.resolve(before, Fixtures.ACTION_ID, GameRng.from_state(before)))
	assert_true(after.rng_state != before.rng_state, "rng advanced")
	assert_eq(after.attempts_of(Fixtures.ACTION_ID), 1, "attempt counted")
	assert_eq(after.flags, before.flags, "flags unchanged")
	assert_eq(after.rng_seed, before.rng_seed, "seed unchanged")

func test_failure_message_never_repeats_the_previous_one() -> void:
	var resolver := ActionResolver.new(Fixtures.game(0.0))
	var state := Fixtures.started_state(resolver)
	for i in 50:
		var previous := state.message_id
		state = StateReducer.fold(state, resolver.resolve(state, Fixtures.ACTION_ID, GameRng.from_state(state)))
		assert_true(state.message_id != previous, "attempt %d repeated %s" % [i, previous])

func test_single_failure_message_can_repeat() -> void:
	var resolver := ActionResolver.new(Fixtures.game(0.0, ["fail_1"]))
	var state := Fixtures.started_state(resolver)
	for i in 3:
		state = StateReducer.fold(state, resolver.resolve(state, Fixtures.ACTION_ID, GameRng.from_state(state)))
		assert_eq(state.message_id, &"fail_1", "attempt %d message" % i)

func test_unavailable_action_emits_no_events() -> void:
	var resolver := ActionResolver.new(Fixtures.game(1.0))
	var state := Fixtures.started_state(resolver)
	state = StateReducer.fold(state, resolver.resolve(state, Fixtures.ACTION_ID, GameRng.from_state(state)))
	assert_true(resolver.resolve(state, Fixtures.ACTION_ID, GameRng.from_state(state)).is_empty(), "no events")

func test_same_seed_and_presses_give_same_events() -> void:
	assert_eq(_play(Fixtures.SEED, 20), _play(Fixtures.SEED, 20), "event logs")

func test_success_rate_is_close_to_chance() -> void:
	var resolver := ActionResolver.new(Fixtures.game(0.25))
	var successes := 0
	for seed_value in 2000:
		var state := StateReducer.fold(GameState.new(), resolver.start(seed_value))
		var attempt := resolver.resolve(state, Fixtures.ACTION_ID, GameRng.from_state(state))[0] as Events.ActionAttempted
		successes += 1 if attempt.success else 0
	var rate := successes / 2000.0
	assert_true(rate > 0.22 and rate < 0.28, "success rate %.3f is not close to 0.25" % rate)

## Event dictionaries produced by starting with the seed and pressing the lighter n times.
func _play(seed_value : int, presses : int) -> Array:
	var resolver := ActionResolver.new(Fixtures.game())
	var events : Array[Events.Event] = resolver.start(seed_value)
	var state := StateReducer.fold(GameState.new(), events)
	for i in presses:
		var step := resolver.resolve(state, Fixtures.ACTION_ID, GameRng.from_state(state))
		events.append_array(step)
		state = StateReducer.fold(state, step)
	return events.map(func(event : Events.Event) -> Dictionary: return event.to_dict())

## Types of the given events, in order.
func _types(events : Array[Events.Event]) -> Array:
	return events.map(func(event : Events.Event) -> StringName: return event.type)
