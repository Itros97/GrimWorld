extends TestCase
## Behaviours 2 to 4 of the placeholder audio spec: which events trigger which sounds.

func test_failed_attempt_only_plays_the_flint() -> void:
	var events : Array[Events.Event] = [
		Events.ActionAttempted.new(SoundCues.LIGHTER_ACTION, false, 1),
		Events.MessageShown.new(&"lighter_fail_1"),
	]
	assert_eq(SoundCues.from_events(events), [SoundCues.FLINT], "cues")

func test_successful_attempt_plays_the_flint_then_marks_the_lighter_lit() -> void:
	var events : Array[Events.Event] = [
		Events.ActionAttempted.new(SoundCues.LIGHTER_ACTION, true, 1),
		Events.FlagSet.new(SoundCues.LIGHTER_FLAG),
		Events.MessageShown.new(&"lighter_lit"),
	]
	assert_eq(SoundCues.from_events(events), [SoundCues.FLINT, SoundCues.LIGHTER_LIT], "cues")

func test_game_start_plays_nothing() -> void:
	var events := ActionResolver.new(Fixtures.game()).start(Fixtures.SEED)
	assert_eq(SoundCues.from_events(events), [], "cues")

func test_empty_batch_plays_nothing() -> void:
	assert_eq(SoundCues.from_events([]), [], "cues")

func test_other_actions_and_flags_play_nothing() -> void:
	var events : Array[Events.Event] = [
		Events.ActionAttempted.new(&"search_room", true, 1),
		Events.FlagSet.new(&"room_searched"),
	]
	assert_eq(SoundCues.from_events(events), [], "cues")
