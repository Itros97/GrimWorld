extends Node
## Autoload that plays the room ambience and turns recorded events into sounds. Holds no game logic.
## Audio files are not in the repository (see README); a missing one is skipped with a warning.

const LIT_AMBIENCE_PATH := "res://assets/sounds/lit_ambience.mp3"
const ROOM_TONE_PATH := "res://assets/sounds/wind_loop.ogg"
const FLINT_PATHS : Array[String] = [
	"res://assets/sounds/zippo_open.wav",
]

const SFX_BUS := &"SFX"
const AMBIENT_BUS := &"Ambient"

const FLINT_PITCH_SPREAD := 1.1
const LIGHTER_LIT_FADE_SECONDS := 1.5
const LIT_AMBIENCE_DB := -8.0
const ROOM_TONE_DB := -10.0
const SILENT_DB := -40.0

var _flint : AudioStreamPlayer
var _lit_ambience : AudioStreamPlayer
var _room_tone : AudioStreamPlayer

func _ready() -> void:
	_flint = _add_player(_flint_randomizer(), SFX_BUS)
	_lit_ambience = _add_player(_load_loop(LIT_AMBIENCE_PATH), AMBIENT_BUS)
	_room_tone = _add_player(_load_loop(ROOM_TONE_PATH), AMBIENT_BUS)
	_room_tone.volume_db = ROOM_TONE_DB
	GameManager.EVENTS_RECORDED.connect(_on_events_recorded)
	# The wind never stops: the room exists even while it is dark.
	_room_tone.play()

func _on_events_recorded(events : Array[Events.Event]) -> void:
	for cue in SoundCues.from_events(events):
		match cue:
			SoundCues.FLINT:
				_flint.play()
			SoundCues.LIGHTER_LIT:
				_fade_in_lit_ambience()

## Starts the lit-room ambience with a fade-in so it does not pop.
func _fade_in_lit_ambience() -> void:
	_lit_ambience.volume_db = SILENT_DB
	_lit_ambience.play()
	create_tween().tween_property(_lit_ambience, "volume_db", LIT_AMBIENCE_DB, LIGHTER_LIT_FADE_SECONDS)

## Child player for the stream, routed to the bus; a null stream makes it silent.
func _add_player(stream : AudioStream, bus : StringName) -> AudioStreamPlayer:
	var player := AudioStreamPlayer.new()
	player.stream = stream
	player.bus = bus
	add_child(player)
	return player

## The audio file at path, or null with a warning when it is not there.
func _load_optional(path : String) -> AudioStream:
	if not ResourceLoader.exists(path):
		push_warning("Missing audio file %s; that sound is skipped" % path)
		return null
	return load(path)

## Looping ambience (Ogg or MP3), or null when the file is missing.
func _load_loop(path : String) -> AudioStream:
	var stream := _load_optional(path)
	if stream == null:
		return null
	stream.set("loop", true)
	return stream

## Picks a random flint variant with a slight pitch change on every play.
func _flint_randomizer() -> AudioStreamRandomizer:
	var randomizer := AudioStreamRandomizer.new()
	randomizer.random_pitch = FLINT_PITCH_SPREAD
	for path in FLINT_PATHS:
		var stream := _load_optional(path)
		if stream != null:
			randomizer.add_stream(-1, stream)
	return randomizer
