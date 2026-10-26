extends MarginContainer
## Paints the current message and one button per available action. Holds no game logic.

@onready var _message_label : Label = %MessageLabel
@onready var _action_list : VBoxContainer = %ActionList
@onready var _credits_button : Button = %CreditsButton
@onready var _credits_panel : PanelContainer = %CreditsPanel

func _ready() -> void:
	_credits_button.pressed.connect(_credits_panel.show)
	GameManager.STATE_CHANGED.connect(_render)
	_render(GameManager.state)

## Rebuilds the screen from the state.
func _render(state : GameState) -> void:
	_message_label.text = GameManager.game.message(state.message_id)
	for child in _action_list.get_children():
		child.queue_free()
	for action in Availability.available_actions(state, GameManager.game):
		var button := Button.new()
		button.text = action.label
		button.pressed.connect(GameManager.action_requested.emit.bind(action.id))
		_action_list.add_child(button)
