class_name SoundCues
extends RefCounted
## Pure mapping from recorded events to the sounds they should trigger. Never plays anything itself.

const FLINT := &"flint"
const LIGHTER_LIT := &"lighter_lit"

const LIGHTER_ACTION := &"light_lighter"
const LIGHTER_FLAG := &"lighter_lit"

## Sound cues for the events, in the order they happened.
static func from_events(events : Array[Events.Event]) -> Array[StringName]:
	var cues : Array[StringName] = []
	for event in events:
		match event.type:
			Events.ACTION_ATTEMPTED:
				if (event as Events.ActionAttempted).action == LIGHTER_ACTION:
					cues.append(FLINT)
			Events.FLAG_SET:
				if (event as Events.FlagSet).id == LIGHTER_FLAG:
					cues.append(LIGHTER_LIT)
	return cues
