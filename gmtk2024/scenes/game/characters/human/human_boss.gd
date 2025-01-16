extends CharacterBody2D
class_name Boss2

@export var speed = 100
@export var jump = 100
@export var damage = 100
@export var gravity = 500

@onready var attack_timer = $AttackTimer
@onready var splash_box = $SwordBox/CollisionShape2D
@onready var animated_sprite = $Sprite2D
var attack_cooldown = null

var player_target = null
var player_target_direction = "left"
var direction = 0
var attacking = false
var tired = false

signal hit_player

func _ready():
	disable_splashbox()
	var get_player = get_tree().get_first_node_in_group("player")
	player_target = get_player
	attack_cooldown = attack_timer.get_wait_time()


func get_distance():
	if ((player_target.global_position.x - global_position.x) <  0):
		return global_position.x - player_target.global_position.x
	else:
		return player_target.global_position.x - global_position.x

func _physics_process(delta):
	if  player_target_direction == "left":
		animated_sprite.flip_h = false
		pass
	else:
		animated_sprite.flip_h = true
		pass
	if is_on_floor() == false && attacking == false:
		velocity.y += gravity * delta
	
	elif attacking == false:
		walk_towards()
	if attacking == true:
		pass
	if player_target.global_position.x < global_position.x:
		player_target_direction = "left"
	else:
		player_target_direction = "right"
	move_and_slide()
	pass


##Have the slime move towards the player
func walk_towards():
	if tired == true:
		velocity.x = 0
		return
	if get_distance() < 200:
		#print('test')
		if player_target_direction == "left":
			velocity.x = (speed * 2)
		else: 
			velocity.x = -(speed * 2)
		return
	if player_target_direction == "left":
		velocity.x = -speed
	else:
		velocity.x = speed
	if get_distance() > 200 && get_distance() < 320 && attack_timer.time_left == 0:
		#splash_box.disabled = false
		start_attack()
		velocity.x = 0
	pass

func start_attack():
	attacking = true
	await get_tree().create_timer(1.0).timeout
	print("SWING!")
	if player_target_direction == "left":
		velocity.x = -500
	else: 
		velocity.x = 500
	splash_box.disabled = false
	$AnimationPlayer.play("attack")
	await get_tree().create_timer(0.5).timeout
	splash_box.disabled = true
	attacking = false
	tired = true
	await get_tree().create_timer(2).timeout
	tired = false

func disable_splashbox():
	#print('disabling!')
	splash_box.disabled = true
	pass

func _on_splash_box_body_entered(body):
	if splash_box.disabled == true:
		pass
	else:
		hit_player.emit()
	##use direction
	if player_target_direction == "left":
		velocity.x = 500
		player_target.velocity.x = -200
	else:
		velocity.x = -500
		player_target.velocity.x = 200
	pass # Replace with function body.


func _on_attack_timer_timeout():
	#splash_box.disabled = false
	pass # Replace with function body.


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "attack":
		pass
		#jump_to()
