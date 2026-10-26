class_name LoadResult
extends RefCounted
## Outcome of loading a data file (GameData, CreditsData...): the data when valid, or every problem found.

var data : RefCounted
var errors : Array[String] = []

func _init(p_data : RefCounted, p_errors : Array[String]) -> void:
	data = p_data if p_errors.is_empty() else null
	errors = p_errors

## Whether the data loaded without errors.
func is_ok() -> bool:
	return errors.is_empty()
