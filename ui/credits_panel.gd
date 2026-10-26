extends PanelContainer
## Overlay with the credits of third-party works and the thanks. Holds no game logic.

const CREDITS_PATH := "res://data/credits.json"

@onready var _title_label : Label = %TitleLabel
@onready var _credits_label : Label = %CreditsLabel
@onready var _thanks_label : Label = %ThanksLabel
@onready var _close_button : Button = %CloseButton

func _ready() -> void:
	_close_button.pressed.connect(hide)
	var result := CreditsData.parse(FileAccess.get_file_as_string(CREDITS_PATH))
	if not result.is_ok():
		for error in result.errors:
			push_error("%s: %s" % [CREDITS_PATH, error])
		return
	_render(result.data)

## Fills the labels from the credits.
func _render(data : CreditsData) -> void:
	_title_label.text = data.title
	_credits_label.text = "\n".join(data.credits.map(func(credit : CreditData) -> String: return credit.line()))
	_thanks_label.text = data.thanks
