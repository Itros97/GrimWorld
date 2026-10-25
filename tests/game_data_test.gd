extends TestCase
## Edge cases of the phase 1 spec: game data is validated when it is loaded.

const GAME_JSON := "res://data/game.json"

func test_real_game_data_loads() -> void:
	var result := GameData.parse(FileAccess.get_file_as_string(GAME_JSON))
	assert_true(result.is_ok(), "errors: %s" % ", ".join(result.errors))

func test_valid_fixture_loads_its_action() -> void:
	var result := GameData.parse(JSON.stringify(Fixtures.game_dict()))
	assert_true(result.is_ok(), "fixture loads")
	assert_eq(result.data.find_action(Fixtures.ACTION_ID).chance, 0.25, "chance")

func test_malformed_json_fails_with_line() -> void:
	_assert_fails('{ "start_message": ', "line")

func test_non_object_root_fails() -> void:
	_assert_fails("[]", "root")

func test_chance_above_one_fails() -> void:
	_assert_fails(JSON.stringify(Fixtures.game_dict(1.5)), "actions[0].chance")

func test_negative_chance_fails() -> void:
	_assert_fails(JSON.stringify(Fixtures.game_dict(-0.1)), "actions[0].chance")

func test_missing_field_fails() -> void:
	var dict := Fixtures.game_dict()
	dict.actions[0].erase("label")
	_assert_fails(JSON.stringify(dict), "actions[0].label")

func test_unknown_message_reference_fails() -> void:
	var dict := Fixtures.game_dict()
	dict.actions[0].success.message = "missing"
	_assert_fails(JSON.stringify(dict), "actions[0].success.message")

func test_empty_failure_messages_fail() -> void:
	_assert_fails(JSON.stringify(Fixtures.game_dict(0.25, [])), "actions[0].failure_messages")

func test_duplicate_action_id_fails() -> void:
	var dict := Fixtures.game_dict()
	dict.actions.append(dict.actions[0].duplicate(true))
	_assert_fails(JSON.stringify(dict), "actions[1].id")

func test_unknown_action_is_not_found() -> void:
	assert_eq(Fixtures.game().find_action(&"missing"), null, "unknown action")

## Asserts that parsing fails with an error mentioning the given path.
func _assert_fails(json_text : String, expected_path : String) -> void:
	var result := GameData.parse(json_text)
	assert_true(not result.is_ok(), "expected errors for %s" % expected_path)
	var mentioned := result.errors.any(func(error : String) -> bool: return error.contains(expected_path))
	assert_true(mentioned, "no error mentions %s: %s" % [expected_path, result.errors])
