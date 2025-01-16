class_name AnimationComponent extends Node

@export var scale_factor: float = 1.1
@export var hover_color: Color = Color(1, 0.8, 0.2)  # A golden yellow color
@export var transition_duration: float = 0.2

var original_scale: Vector2
var original_color: Color
var tween: Tween

@onready var parent_button: Button = get_parent()

func _ready() -> void:
	if not parent_button:
		push_error("AnimationComponent must be a child of a Button node")
		return

	original_scale = parent_button.scale
	original_color = parent_button.modulate

	parent_button.mouse_entered.connect(_on_mouse_entered)
	parent_button.mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered() -> void:
	_animate_hover(true)

func _on_mouse_exited() -> void:
	_animate_hover(false)

func _animate_hover(is_hovering: bool) -> void:
	if tween:
		tween.kill()

	tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	if is_hovering:
		tween.parallel().tween_property(parent_button, "scale", original_scale * scale_factor, transition_duration)
		tween.parallel().tween_property(parent_button, "modulate", hover_color, transition_duration)
	else:
		tween.parallel().tween_property(parent_button, "scale", original_scale, transition_duration)
		tween.parallel().tween_property(parent_button, "modulate", original_color, transition_duration)
