class_name TestCase
extends RefCounted
## Base class for test suites: assertions record failures instead of stopping the run.

var failures : PackedStringArray = []

## Records a failure when actual and expected differ.
func assert_eq(actual : Variant, expected : Variant, message : String = "") -> void:
	if actual == expected:
		return
	failures.append("%s: expected %s, got %s" % [message, expected, actual])

## Records a failure when the condition is false.
func assert_true(condition : bool, message : String) -> void:
	if condition:
		return
	failures.append(message)
