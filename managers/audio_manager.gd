extends Node
## Autoload that plays the music and turns recorded events into sounds. Holds no game logic.
## Audio files are not in the repository (see README); a missing one is skipped with a warning.

const MUSIC_PATH := "res://assets/music/main_screen.ogg"
const LIT_AMBIENCE_PATH := "res://assets/sounds/lit_ambience.mp3"
const FLINT_PATHS : Array[String] = [
	"res://assets/sounds/lighter.wav",
]

const MUSIC_BUS := &"Music"
const SFX_BUS := &"SFX"
const AMBIENT_BUS := &"Ambient"

const FLINT_PITCH_SPREAD := 1.1
const LIGHTER_LIT_FADE_SECONDS := 1.5
const SILENT_DB := -40.0

var _music : AudioStreamPlayer
var _flint : AudioStreamPlayer
var _lit_ambience : AudioStreamPlayer

func _ready() -> void:
	_music = _add_player(_load_loop(MUSIC_PATH), MUSIC_BUS)
	_flint = _add_player(_flint_randomizer(), SFX_BUS)
	_lit_ambience = _add_player(_load_loop(LIT_AMBIENCE_PATH), AMBIENT_BUS)
	GameManager.EVENTS_RECORDED.connect(_on_events_recorded)
	_music.play()

func _on_events_recorded(events : Array[Events.Event]) -> void:
	for cue in SoundCues.from_events(events):
		match cue:
			SoundCues.FLINT:
				_flint.play()
			SoundCues.LIGHTER_LIT:
				_crossfade_to_lit_ambience()

## Fades the music out while the lit-room ambience fades in, so neither pops.
func _crossfade_to_lit_ambience() -> void:
	_lit_ambience.volume_db = SILENT_DB
	_lit_ambience.play()
	var tween := create_tween().set_parallel()
	tween.tween_property(_lit_ambience, "volume_db", 0.0, LIGHTER_LIT_FADE_SECONDS)
	tween.tween_property(_music, "volume_db", SILENT_DB, LIGHTER_LIT_FADE_SECONDS)
	tween.chain().tween_callback(_music.stop)

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

## Looping music or ambience (Ogg or MP3), or null when the file is missing.
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
