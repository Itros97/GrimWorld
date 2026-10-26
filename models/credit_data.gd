class_name CreditData
extends RefCounted
## One third-party work used by the game: what it is used for, who made it and its licence.

var role : String
var work : String
var author : String
var source : String
var licence : String

## Builds the credit from its JSON object; appends to errors every field that is wrong.
static func from(dict : Dictionary, path : String, errors : Array[String]) -> CreditData:
	var credit := CreditData.new()
	credit.role = JsonReader.read_string(dict, "role", path, errors)
	credit.work = JsonReader.read_string(dict, "work", path, errors)
	credit.author = JsonReader.read_string(dict, "author", path, errors)
	credit.source = JsonReader.read_string(dict, "source", path, errors)
	credit.licence = JsonReader.read_string(dict, "licence", path, errors)
	return credit

## One readable line, e.g. "Música: «Work», de author (Freesound, CC0)".
func line() -> String:
	return "%s: «%s», de %s (%s, %s)" % [role, work, author, source, licence]
