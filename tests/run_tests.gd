extends SceneTree
## Runs every *_test.gd suite in res://tests and exits with code 1 if any test fails.
## Usage: godot --headless -s tests/run_tests.gd

const TESTS_DIR := "res://tests"
const SUITE_SUFFIX := "_test.gd"
const TEST_PREFIX := "test_"

func _init() -> void:
	var total := 0
	var failed := 0
	for file in DirAccess.get_files_at(TESTS_DIR):
		if not file.ends_with(SUITE_SUFFIX):
			continue
		print(file)
		var suite : TestCase = load(TESTS_DIR.path_join(file)).new()
		for method in suite.get_method_list():
			var test_name : String = method.name
			if not test_name.begins_with(TEST_PREFIX):
				continue
			total += 1
			if not _run_test(suite, test_name):
				failed += 1
	print("\n%d tests, %d failed" % [total, failed])
	quit(1 if failed > 0 else 0)

## Runs one test method and prints its result; returns true when it passed.
func _run_test(suite : TestCase, test_name : String) -> bool:
	suite.failures.clear()
	suite.call(test_name)
	var label := test_name.trim_prefix(TEST_PREFIX).replace("_", " ")
	if suite.failures.is_empty():
		print("  ✓ %s" % label)
		return true
	print("  ✗ %s" % label)
	for failure in suite.failures:
		print("      %s" % failure)
	return false
