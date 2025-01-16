class_name AnimationComponentExit extends Node

@export var hover_color: Color = Color(1, 0.3, 0.3)  # Reddish color
@export var transition_duration: float = 0.5
@export var flicker_speed: float = 0.5
@export var flicker_intensity: float = 0.3

var original_modulate: Color
var original_text: String
var tween: Tween
var flicker_tween: Tween

@onready var parent_button: Button = get_parent()

func _ready() -> void:
	if not parent_button:
		push_error("ExitButtonPowerDownAnimation must be a child of a Button node")
		return

	original_modulate = parent_button.modulate
	original_text = parent_button.text

	parent_button.mouse_entered.connect(_on_mouse_entered)
	parent_button.mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered() -> void:
	_start_power_down_animation()

func _on_mouse_exited() -> void:
	_stop_power_down_animation()

func _start_power_down_animation() -> void:
	if tween and tween.is_valid():
		tween.kill()
	if flicker_tween and flicker_tween.is_valid():
		flicker_tween.kill()

	tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween.tween_property(parent_button, "modulate", hover_color, transition_duration)
	tween.parallel().tween_method(_update_text_effect, 0.0, 1.0, transition_duration)
	tween.tween_callback(_start_flicker_effect)

func _stop_power_down_animation() -> void:
	if tween and tween.is_valid():
		tween.kill()
	if flicker_tween and flicker_tween.is_valid():
		flicker_tween.kill()

	tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(parent_button, "modulate", original_modulate, transition_duration / 2)
	tween.parallel().tween_method(_update_text_effect, 1.0, 0.0, transition_duration / 2)
	tween.tween_callback(_reset_button_text)

func _update_text_effect(progress: float) -> void:
	var text = original_text
	var affected_chars = int(text.length() * progress)
	var new_text = ""
	for i in range(text.length()):
		if i < affected_chars:
			new_text += char(0x25CF)  # Unicode "Black Circle" character
		else:
			new_text += text[i]
	parent_button.text = new_text

func _start_flicker_effect() -> void:
	flicker_tween = create_tween().set_loops()
	flicker_tween.tween_method(_flicker_effect, 0.0, 1.0, flicker_speed)
	flicker_tween.tween_method(_flicker_effect, 1.0, 0.0, flicker_speed)

func _flicker_effect(value: float) -> void:
	parent_button.modulate = hover_color.lerp(Color(0, 0, 0, 1), value * flicker_intensity)

func _reset_button_text() -> void:
	parent_button.text = original_text

func _exit_tree() -> void:
	if tween and tween.is_valid():
		tween.kill()
	if flicker_tween and flicker_tween.is_valid():
		flicker_tween.kill()
