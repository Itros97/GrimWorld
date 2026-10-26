extends TestCase
## Light and grain specs: the screen look follows the brightest light level whose flag is set.

func test_no_flag_uses_darkness() -> void:
	var game := _game()
	assert_eq(game.light_level(GameState.new()), game.darkness, "level")
	assert_eq(game.darkness.grain, 0.06, "darkness grain")

func test_lit_lighter_uses_its_level() -> void:
	var level := _game().light_level(_state_with([&"lighter_lit"]))
	assert_eq(level.background, Color.html("#2a1608"), "background")
	assert_eq(level.text, Color.html("#f2e6d8"), "text")
	assert_eq(level.grain, 0.04, "grain")
	assert_eq(level.flicker, 0.15, "flicker")

func test_last_active_level_wins() -> void:
	var level := _game().light_level(_state_with([&"lighter_lit", &"fire_burning"]))
	assert_eq(level.flag, &"fire_burning", "flag")

func test_levels_are_optional() -> void:
	var game := Fixtures.game()
	assert_eq(game.light_level(_state_with([&"lighter_lit"])), game.darkness, "level")

func test_missing_grain_and_flicker_are_zero() -> void:
	var level := _game().light_level(_state_with([&"lighter_lit", &"fire_burning"]))
	assert_eq([level.grain, level.flicker], [0.0, 0.0], "grain and flicker")

func test_flicker_out_of_range_fails_naming_the_field() -> void:
	var dict := _game_dict()
	dict.light_levels[0].flicker = 1.5
	_assert_fails(dict, "light_levels[0].flicker")

func test_missing_darkness_fails() -> void:
	var dict := _game_dict()
	dict.erase("darkness")
	_assert_fails(dict, "darkness")

func test_blend_halfway_mixes_every_value() -> void:
	var from := LightLevelData.with(&"", Color.BLACK, Color.WHITE, 0.2, 0.0)
	var to := LightLevelData.with(&"lit", Color.WHITE, Color.BLACK, 0.0, 0.4)
	var half := from.blend(to, 0.5)
	assert_eq([half.background, half.text, half.grain, half.flicker], [Color(0.5, 0.5, 0.5), Color(0.5, 0.5, 0.5), 0.1, 0.2], "halfway")

func test_invalid_colour_fails_naming_the_field() -> void:
	var dict := _game_dict()
	dict.light_levels[0].background = "orange-ish"
	_assert_fails(dict, "light_levels[0].background")

func _game_dict() -> Dictionary:
	var dict := Fixtures.game_dict()
	dict.darkness = { "background": "#050505", "text": "#dfdfdf", "grain": 0.06 }
	dict.light_levels = [
		{ "flag": "lighter_lit", "background": "#2a1608", "text": "#f2e6d8", "grain": 0.04, "flicker": 0.15 },
		{ "flag": "fire_burning", "background": "#8a5a30", "text": "#1a1008" },
	]
	return dict

func _game() -> GameData:
	var result := GameData.parse(JSON.stringify(_game_dict()))
	assert(result.is_ok(), "Invalid light fixture: %s" % ", ".join(result.errors))
	return result.data

func _state_with(flags : Array[StringName]) -> GameState:
	var state := GameState.new()
	for flag in flags:
		state.flags[flag] = true
	return state

func _assert_fails(dict : Dictionary, expected_path : String) -> void:
	var errors := ", ".join(GameData.parse(JSON.stringify(dict)).errors)
	assert_true(errors.contains(expected_path), "an error names %s: %s" % [expected_path, errors])
