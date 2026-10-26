class_name LightLevelData
extends RefCounted
## How the screen looks under some light: colours, film grain and flame flicker. Defined in data/game.json.

var flag : StringName
var background : Color
var text : Color
var grain : float
var flicker : float

## Light level with these values.
static func with(p_flag : StringName, p_background : Color, p_text : Color, p_grain : float = 0.0, p_flicker : float = 0.0) -> LightLevelData:
	var level := LightLevelData.new()
	level.flag = p_flag
	level.background = p_background
	level.text = p_text
	level.grain = p_grain
	level.flicker = p_flicker
	return level

## Builds a flagged level from its JSON object; appends to errors every field that is wrong.
static func from(dict : Dictionary, path : String, errors : Array[String]) -> LightLevelData:
	var level := look_from(dict, path, errors)
	level.flag = JsonReader.read_string(dict, "flag", path, errors)
	return level

## Builds a level without flag (such as darkness) from its JSON object.
static func look_from(dict : Dictionary, path : String, errors : Array[String]) -> LightLevelData:
	return with(
		&"",
		JsonReader.read_color(dict, "background", path, errors),
		JsonReader.read_color(dict, "text", path, errors),
		JsonReader.read_optional_number(dict, "grain", path, errors, 0.0, 1.0),
		JsonReader.read_optional_number(dict, "flicker", path, errors, 0.0, 1.0),
	)

## Look part of the way from this level to the target; weight 0 is this one, 1 is the target.
func blend(target : LightLevelData, weight : float) -> LightLevelData:
	return with(
		target.flag,
		background.lerp(target.background, weight),
		text.lerp(target.text, weight),
		lerpf(grain, target.grain, weight),
		lerpf(flicker, target.flicker, weight),
	)
