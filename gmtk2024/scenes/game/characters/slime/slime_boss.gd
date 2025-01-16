extends CharacterBody2D
class_name Boss

@export var speed = 100
@export var jump = 100
@export var damage = 100
@export var gravity = 500

@onready var attack_timer = $AttackTimer
@onready var splash_box = $SplashBox/CollisionShape2D
var attack_cooldown = null

var player_target = null
var player_target_direction = "left"
var direction = 0
var attacking = false

signal hit_player

func _ready():
	#splash_box.disabled = true
	var get_player = get_tree().get_first_node_in_group("player")
	player_target = get_player
	attack_cooldown = attack_timer.get_wait_time()
	#attack_timer.


func get_distance():
	if ((player_target.global_position.x - global_position.x) <  0):
		return global_position.x - player_target.global_position.x
	else:
		return player_target.global_position.x - global_position.x

func _physics_process(delta):
	#print(attack_timer.time_left)
	if is_on_floor() == false && attacking == false:
		velocity.y += gravity * delta
	
	elif attacking == false:
		walk_towards()
	if attacking == true:
		start_jump()
	if player_target.global_position.x < global_position.x:
		player_target_direction = "left"
	else:
		player_target_direction = "right"
	move_and_slide()
	pass


##Have the slime move towards the player
func walk_towards():
	if get_distance() < 200:
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
		splash_box.disabled = false
		attacking = true
		velocity.x = 0
	pass
func start_jump():
	$AnimationPlayer.play("attack")
##Have the slime jump onto the player
func jump_to():
	var slime_tween = create_tween()
	var target_position = Vector2(
		player_target.global_position.x,
		player_target.global_position.y - 200
	)
	slime_tween.tween_property(self, "global_position", target_position, 1)
	slime_tween.finished.connect(drop_to)
	await slime_tween.finished
	drop_to()
	pass

func drop_to():
	$AnimationPlayer.play("move")
	attacking = false
	attack_timer.start(attack_cooldown)
	var hitbox_timer = null
	if hitbox_timer == null:
		hitbox_timer = get_tree().create_timer(2)
		hitbox_timer.timeout.connect(disable_splashbox)
	pass

func disable_splashbox():
	#print('disabling!')
	splash_box.disabled = true
	pass

func _on_splash_box_body_entered(body):
	#print(body)
	if splash_box.disabled == true:
		pass
	else:
		hit_player.emit()
		#disable_splashbox()
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
		jump_to()
