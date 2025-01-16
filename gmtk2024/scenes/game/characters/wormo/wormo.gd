extends CharacterBody2D
class_name Player

@export var speed := 75.0
@export var gravity := 500
@export var jump_force := 100

@export var max_jump := 400
#This should be named jump_charge_acceleration but I'm too lazy
@export var jump_acceleration = 5
@export var jump_x_damp = 0.2

var active := true
var is_charging := false
var is_maxxed = jump_force > max_jump
var direction = 0
var is_stage_rat = true
var is_stage_slime = true
var is_stage_human = true
var particle_refresh = true

#saving the previous velocity for wall bouncing, we are now too invested to refactor the movement lmao
var prev_velocityX = 0

@onready var animated_sprite = $AnimatedSprite2D
@onready var collision_box = $CollisionShape2D
var base_collision_size = null
@onready var grunts_sfx = [
	preload("res://assets/sounds/Wormo Grunt 1.wav"), 
	preload("res://assets/sounds/Wormo Grunt 2.wav"), 
	#preload("res://assets/sounds/Wormo Grunt 3.wav")
]
@onready var sproing_sfx = [
	preload("res://assets/sounds/Wormo Sproing.wav"),
	preload("res://assets/sounds/Wormo Sproing Crunchy.wav"),
]
##TODO SFX 

func _ready():
	base_collision_size = collision_box.shape.size

func jump_release(force):
	collision_box.shape.size = Vector2(15, 40)
	
	velocity.y = -force
	if animated_sprite.flip_h == false:
		velocity.x = force * jump_x_damp
	else:
		velocity.x = (force * jump_x_damp) * -1
	if force < max_jump / 2:
		GlobalTheme.play_sfx(sproing_sfx[0], 0.0)
		pass
	else:
		GlobalTheme.play_sfx(sproing_sfx[1], 0.0)
		pass

func _physics_process(delta):
	if is_on_wall() == true && velocity.y < 0:
		velocity.x = prev_velocityX * -1
	velocity.y += gravity * delta
	if velocity.y > 0 && is_on_floor() == false:
		animated_sprite.flip_v = true
		velocity.x += direction * (speed * 0.02)
	else:
		if is_stage_rat == true:
			if particle_refresh == true:
				$ratparticle1.emitting = true
				$ratparticle2.emitting = true
				particle_refresh = false
		if is_stage_slime == true && particle_refresh == true:
			$slimeparticle1.emitting = true
			$slimeparticle2.emitting = true
		animated_sprite.flip_v = false
	if velocity.y > 500:
		velocity.y = 500
	if active == true:
		if Input.is_action_just_released("jump") && is_on_floor() == true:
			animated_sprite.offset = Vector2(0,0)
			jump_release(jump_force)
			is_charging = false
			jump_force = 100
			pass
		if Input.is_action_pressed("jump") && is_on_floor() == true:
			velocity.x = 0
			is_charging = true
			if is_charging == true && jump_force == 100 + (jump_acceleration * 24):
				var random = randi_range(1,grunts_sfx.size()) - 1
				GlobalTheme.play_sfx(grunts_sfx[random], 0.0)
			if jump_force < max_jump:
				jump_force += jump_acceleration
				pass
			pass
		if is_charging == false:
			direction = Input.get_axis("move_left", "move_right")
			pass
		if direction != 0:
			animated_sprite.flip_h = (direction == -1)
	if is_on_floor() == true && Input.is_action_just_released("jump") == false && Input.is_action_pressed("jump") == false:
		collision_box.shape.size = base_collision_size
		velocity.x = direction * speed
	prev_velocityX = velocity.x
	if is_on_floor() == true:
		particle_refresh = true
	move_and_slide()
	update_animations(direction)
	pass

func update_animations(in_direction):
	if jump_force == max_jump:
		shake()
	if is_on_floor():
		if is_charging == true && animated_sprite.animation != "charge":
			animated_sprite.play("charge")
		if in_direction == 0:
			if is_charging == false:
				animated_sprite.play("idle")
		elif is_charging == false:
			animated_sprite.play("run")
		pass
	else:
		if velocity.y < 0:
			animated_sprite.play("jump")
		else:
			animated_sprite.play("fall")
		pass
	pass

func shake():
	var tween = get_tree().create_tween()
	var random = Vector2(randi_range(0,1), randi_range(0, 1))
	tween.tween_property(animated_sprite, "offset", random, 0.1)
	pass
