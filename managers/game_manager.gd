extends Node
## Autoload that orchestrates the game: owns the event log, resolves requested actions and broadcasts the new state.

signal action_requested(action_id : StringName)
signal STATE_CHANGED(state : GameState)

const DATA_PATH := "res://data/game.json"
const SEED_ARG := "--seed="

var game : GameData
var state : GameState = GameState.new()
var _events : Array[Events.Event] = []
var _resolver : ActionResolver

func _ready() -> void:
	var result := GameData.parse(FileAccess.get_file_as_string(DATA_PATH))
	if not result.is_ok():
		for error in result.errors:
			push_error("%s: %s" % [DATA_PATH, error])
		get_tree().quit(1)
		return
	game = result.data
	_resolver = ActionResolver.new(game)
	action_requested.connect(_on_action_requested)
	_record(_resolver.start(_read_seed()))

## Seed from "-- --seed=N" on the command line, or a random one for a new game.
func _read_seed() -> int:
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with(SEED_ARG):
			return arg.trim_prefix(SEED_ARG).to_int()
	var rng := RandomNumberGenerator.new()
	rng.randomize()
	return rng.randi()

func _on_action_requested(action_id : StringName) -> void:
	_record(_resolver.resolve(state, action_id, GameRng.from_state(state)))

## Appends the events to the log, applies them and notifies listeners.
func _record(events : Array[Events.Event]) -> void:
	if events.is_empty():
		return
	_events.append_array(events)
	state = StateReducer.fold(state, events)
	STATE_CHANGED.emit(state)
