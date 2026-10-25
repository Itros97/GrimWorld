class_name Fixtures
extends RefCounted
## Builds small game data documents for tests, so results do not depend on real content.

const SEED := 12345
const ACTION_ID := &"light_lighter"

## Game data dictionary with one lighter action using the given chance and failure messages.
static func game_dict(chance : float = 0.25, failure_ids : Array = ["fail_1", "fail_2", "fail_3"]) -> Dictionary:
	var messages := { "dark": "It is dark.", "lit": "A flame." }
	for id in failure_ids:
		messages[id] = "Failure %s." % id
	return {
		"start_message": "dark",
		"messages": messages,
		"actions": [{
			"id": String(ACTION_ID),
			"label": "Light lighter",
			"chance": chance,
			"unavailable_if_flag": "lighter_lit",
			"success": { "flag": "lighter_lit", "message": "lit" },
			"failure_messages": failure_ids,
		}],
	}

## Parsed game data for the given chance and failure messages; fails loud if the fixture is invalid.
static func game(chance : float = 0.25, failure_ids : Array = ["fail_1", "fail_2", "fail_3"]) -> GameData:
	var result := GameData.parse(JSON.stringify(game_dict(chance, failure_ids)))
	assert(result.is_ok(), "Invalid fixture: %s" % ", ".join(result.errors))
	return result.data

## State right after starting a game with the fixture seed.
static func started_state(resolver : ActionResolver) -> GameState:
	return StateReducer.fold(GameState.new(), resolver.start(SEED))
