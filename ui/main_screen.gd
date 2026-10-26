extends Control
## Paints the current message, one button per available action and the light of the room. Holds no game logic.
## The background colour, grain and flicker are drawn by light_background.gdshader.

const LIGHT_FADE_SECONDS := 1.5
const BUTTON_FONT_COLORS : Array[StringName] = [&"font_color", &"font_hover_color", &"font_pressed_color", &"font_focus_color"]

@onready var _background : ColorRect = %Background
@onready var _message_label : Label = %MessageLabel
@onready var _action_list : VBoxContainer = %ActionList
@onready var _credits_button : Button = %CreditsButton
@onready var _credits_panel : PanelContainer = %CreditsPanel

var _light : LightLevelData

func _ready() -> void:
	theme = Theme.new()
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
	_show_light(GameManager.game.light_level(state))

## Paints the light level: at once on the first render, with a fade when the light changes.
func _show_light(level : LightLevelData) -> void:
	if level == _light:
		return
	var previous := _light
	_light = level
	if previous == null:
		_paint_light(level)
		return
	create_tween().tween_method(
		func(weight : float) -> void: _paint_light(previous.blend(level, weight)),
		0.0, 1.0, LIGHT_FADE_SECONDS)

## Sends the look to the background shader and sets the text colour of every label and button.
func _paint_light(level : LightLevelData) -> void:
	var material := _background.material as ShaderMaterial
	material.set_shader_parameter(&"base_color", level.background)
	material.set_shader_parameter(&"grain", level.grain)
	material.set_shader_parameter(&"flicker", level.flicker)
	theme.set_color(&"font_color", &"Label", level.text)
	for item in BUTTON_FONT_COLORS:
		theme.set_color(item, &"Button", level.text)
