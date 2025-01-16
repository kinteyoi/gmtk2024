extends Node2D

@export var next_level: PackedScene = null
@export var level_time = 60
@export var is_final_level: bool = false
@export var level_theme: AudioStreamMP3 = null
var player = null
var timer_node = null
var time_left = null
var winCon = false
#var is_slime = false
@export var is_slime = false
@export var is_rat = false
@onready var start = $Start
@onready var exit = $Exit
@onready var death_zone = $Deathzone
@onready var hurt_sfx = preload("res://assets/sounds/SFX/Wormo/Wormo DEATH.wav")

@onready var hud = null

func _ready():
	brian()
	stage()
	arrow()
	$Wormo.is_stage_rat = is_rat
	$Wormo.is_stage_slime = is_slime
	player = get_tree().get_first_node_in_group("player")
	if player != null:
		player.global_position = start.get_spawn_pos()
	var monsters = get_tree().get_nodes_in_group("monster")
	for monster in monsters:
		monster.touched_player.connect(on_monster_touched_player)
	death_zone.body_entered.connect(_on_deathzone_body_entered)
	exit.body_entered.connect(_on_exit_body_entered)
	if level_theme != null:
		GlobalTheme.play_music_level(level_theme)

func reset_player():
	player.velocity = Vector2.ZERO
	player.global_position = start.get_spawn_pos()

func _on_exit_body_entered(body):
	if body is Player:
		if next_level != null:
			await get_tree().create_timer(1).timeout
			get_tree().change_scene_to_packed(next_level)
		else:
			#show win screen here
			pass
	pass
	
func brian():
	if is_slime == true:
		var tween = create_tween()
		tween.tween_property($Slimebrain, "scale", Vector2(2.2, 1.9), 2)
		tween.tween_property($Slimebrain, "scale", Vector2(1.9, 2.2), 2)
		tween.tween_callback(brian)
func stage():
	if is_slime == true:
		var tween = create_tween()
		tween.tween_property($TileMapLayer2, "scale", Vector2(2.01, 1.99), 5)
		tween.tween_property($TileMapLayer2, "scale", Vector2(1.99, 2.01), 5)
		tween.tween_callback(stage)
		
func arrow():
	if is_rat == true:
		var tween = create_tween()
		tween.TRANS_SINE
		tween.tween_property($Arrow, "position", Vector2(3170, -278), 2)
		tween.tween_property($Arrow, "position", Vector2(3170, -300), 2)
		tween.tween_callback(brian)

func on_monster_touched_player(monster):
	GlobalTheme.play_sfx(hurt_sfx)
	reset_player()
	pass

func _on_deathzone_body_entered(_body):
	GlobalTheme.play_sfx(hurt_sfx)
	reset_player()
	pass

func _on_slimedrip_slime() -> void:
	is_slime = true
