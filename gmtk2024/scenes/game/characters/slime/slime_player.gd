extends CharacterBody2D

@onready var _animation_player = $AnimationPlayer
@onready var animated_sprite = $Sprite2D
@onready var bite_box = $BiteBox/CollisionShape2D
@onready var bite_box_parent = $BiteBox
@onready var hurt_box = $HurtBox
var bite_box_init_position = 0
var hurt_box_init_position = 0
var attacking = false

signal hit_boss

@export var speed = 300
@export var jump_force = 500
@export var damage = 100
@export var gravity = 500

var direction = 0
var override_x = false

func _ready():
	bite_box.disabled = true
	bite_box_init_position = bite_box_parent.position
	hurt_box_init_position = hurt_box.position


func jump():
	attacking = true
	velocity.y = -jump_force
	bite_box.disabled = false
	await get_tree().create_timer(1.0).timeout
	attacking = false

func _physics_process(delta):
	if Input.is_action_just_pressed("jump") && is_on_floor() == true:
		#_animation_player.play("jump")
		jump()
	if is_on_floor() == false:
		velocity.y += gravity * delta
	if is_on_floor() == true:
		if attacking == false:
			bite_box.disabled = true
	direction = Input.get_axis("move_left", "move_right")
	direction = direction
	if direction != 0:
		animated_sprite.flip_h = (direction == -1)
	velocity.x = direction * speed
	move_and_slide()
	pass

func update_animations(_direction):
	pass

func _on_animation_player_animation_finished(anim_name):
	pass # Replace with function body.


func _on_bite_box_body_entered(body):
	print("Kill jester!")
	print(body)
	#hit_boss.emit()
	if body is Boss || body is Boss2:
		print('hit boss')
		hit_boss.emit()
		pass
	pass # Replace with function body.
