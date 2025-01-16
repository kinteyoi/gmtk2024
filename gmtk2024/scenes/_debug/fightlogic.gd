extends Node2D

@onready var swingbox = $CharacterBody2D/Area2D/CollisionShape2D
@onready var spawn_timer = $SpawnTimer

var attack = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	swingbox.disabled = true
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		if attack == true:
			swingbox.disabled = false
			attackk()
			attack = false
		
func attackk():
	$CharacterBody2D/AnimationPlayer.play("attack")

func _on_timer_timeout() -> void:
	var FIRE = preload("res://scenes/game/characters/fire.tscn").instantiate()
	FIRE.look_at($CharacterBody2D.global_position)
	get_tree().get_root().add_child(FIRE)
	FIRE.global_position = $Marker2D.global_position
	var randomTimer = randi_range(2,5)
	spawn_timer.start(randomTimer)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == ("attack"):
		attack = true
		swingbox.disabled = true
