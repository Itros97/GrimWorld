class_name CreditsData
extends RefCounted
## Credits and thanks loaded from data/credits.json. Validated on load.

var title : String
var thanks : String
var credits : Array[CreditData] = []

## Parses and validates the JSON text; the result holds every error found, with its field path.
static func parse(json_text : String) -> LoadResult:
	var errors : Array[String] = []
	var dict := JsonReader.parse_object(json_text, errors)
	if not errors.is_empty():
		return LoadResult.new(null, errors)
	return LoadResult.new(from(dict, errors), errors)

## Builds the credits from their root JSON object; appends to errors every field that is wrong.
static func from(dict : Dictionary, errors : Array[String]) -> CreditsData:
	var data := CreditsData.new()
	data.title = JsonReader.read_string(dict, "title", "", errors)
	data.thanks = JsonReader.read_string(dict, "thanks", "", errors)
	var items := JsonReader.read_dict_array(dict, "credits", "", errors)
	for i in items.size():
		data.credits.append(CreditData.from(items[i], "credits[%d]" % i, errors))
	return data
