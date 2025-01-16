extends Node2D

signal slime
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	emit_signal("slime")
	var time = randf_range(3, 5)
	$Timer.wait_time = time


func _on_timer_timeout() -> void:
	$AnimationPlayer.play("drip")
