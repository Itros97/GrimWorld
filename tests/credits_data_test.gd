extends TestCase
## Credits spec: the credits file is validated when it is loaded.

const CREDITS_JSON := "res://data/credits.json"

func test_real_credits_load_with_author_and_work() -> void:
	var result := CreditsData.parse(FileAccess.get_file_as_string(CREDITS_JSON))
	assert_true(result.is_ok(), "errors: %s" % ", ".join(result.errors))
	for credit : CreditData in result.data.credits:
		assert_true(not credit.author.is_empty() and not credit.work.is_empty(), "%s has author and work" % credit.line())

func test_credit_line_names_role_work_author_source_and_licence() -> void:
	var credit := CreditData.from(_credit_dict(), "", [] as Array[String])
	assert_eq(credit.line(), "Música: «Song», de someone (Freesound, CC0)", "line")

func test_credit_without_author_fails() -> void:
	var credit := _credit_dict()
	credit.erase("author")
	var result := CreditsData.parse(JSON.stringify({ "title": "T", "thanks": "Thanks.", "credits": [credit] }))
	assert_true(not result.is_ok(), "fails")
	assert_true(", ".join(result.errors).contains("credits[0].author"), "names the field: %s" % ", ".join(result.errors))

func test_empty_credit_list_fails() -> void:
	var result := CreditsData.parse(JSON.stringify({ "title": "T", "thanks": "Thanks.", "credits": [] }))
	assert_true(", ".join(result.errors).contains("credits"), "names the field: %s" % ", ".join(result.errors))

func _credit_dict() -> Dictionary:
	return { "role": "Música", "work": "Song", "author": "someone", "source": "Freesound", "licence": "CC0" }
