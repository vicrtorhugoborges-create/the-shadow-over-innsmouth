class_name InputSetup
extends RefCounted
## Cria as ações remapeáveis em tempo de execução (sys_settings).
## Teclas padrão podem ser substituídas por `overrides` (action -> physical keycode).

const ACTIONS: Array[String] = [
	"move_forward", "move_back", "move_left", "move_right",
	"run", "crouch", "shamble", "interact", "flashlight",
	"journal", "pause", "close_eyes",
]

const LABELS: Dictionary = {
	"move_forward": "Andar para frente",
	"move_back": "Andar para trás",
	"move_left": "Andar para a esquerda",
	"move_right": "Andar para a direita",
	"run": "Correr",
	"crouch": "Agachar",
	"shamble": "Andar arrastado",
	"interact": "Interagir / examinar",
	"flashlight": "Lanterna",
	"journal": "Diário",
	"pause": "Pausa",
	"close_eyes": "Fechar os olhos",
}

const DEFAULT_KEYS: Dictionary = {
	"move_forward": KEY_W,
	"move_back": KEY_S,
	"move_left": KEY_A,
	"move_right": KEY_D,
	"run": KEY_SHIFT,
	"crouch": KEY_CTRL,
	"shamble": KEY_ALT,
	"interact": KEY_E,
	"flashlight": KEY_F,
	"journal": KEY_J,
	"pause": KEY_ESCAPE,
	"close_eyes": KEY_SPACE,
}

const PAD_BUTTONS: Dictionary = {
	"run": JOY_BUTTON_LEFT_SHOULDER,
	"crouch": JOY_BUTTON_B,
	"shamble": JOY_BUTTON_LEFT_STICK,
	"interact": JOY_BUTTON_A,
	"journal": JOY_BUTTON_Y,
	"pause": JOY_BUTTON_START,
}


static func apply(overrides: Dictionary) -> void:
	for action: String in ACTIONS:
		if InputMap.has_action(action):
			InputMap.erase_action(action)
		InputMap.add_action(action, 0.2)
		var key: int = int(overrides.get(action, DEFAULT_KEYS[action]))
		var ev := InputEventKey.new()
		ev.physical_keycode = key as Key
		InputMap.action_add_event(action, ev)
		if PAD_BUTTONS.has(action):
			var pb := InputEventJoypadButton.new()
			pb.button_index = PAD_BUTTONS[action]
			pb.device = -1
			InputMap.action_add_event(action, pb)
	_add_axis("move_forward", JOY_AXIS_LEFT_Y, -1.0)
	_add_axis("move_back", JOY_AXIS_LEFT_Y, 1.0)
	_add_axis("move_left", JOY_AXIS_LEFT_X, -1.0)
	_add_axis("move_right", JOY_AXIS_LEFT_X, 1.0)
	_add_axis("flashlight", JOY_AXIS_TRIGGER_RIGHT, 1.0)
	_add_axis("close_eyes", JOY_AXIS_TRIGGER_LEFT, 1.0)
	# Arrow keys always move as a fixed secondary binding.
	_add_key("move_forward", KEY_UP)
	_add_key("move_back", KEY_DOWN)
	_add_key("move_left", KEY_LEFT)
	_add_key("move_right", KEY_RIGHT)


static func _add_axis(action: String, axis: JoyAxis, value: float) -> void:
	var ev := InputEventJoypadMotion.new()
	ev.axis = axis
	ev.axis_value = value
	ev.device = -1
	InputMap.action_add_event(action, ev)


static func _add_key(action: String, key: Key) -> void:
	var ev := InputEventKey.new()
	ev.physical_keycode = key
	InputMap.action_add_event(action, ev)


static func key_name(keycode: int) -> String:
	return OS.get_keycode_string(keycode as Key)
