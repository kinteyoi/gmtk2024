extends CharacterBody2D

@onready var _animation_player = $AnimationPlayer
@onready var animated_sprite = $Sprite2D
@onready var bite_box = $BiteBox/CollisionShape2D
@onready var bite_box_parent = $BiteBox
@onready var hurt_box = $HurtBox
var bite_box_init_position = 0
var hurt_box_init_position = 0

signal hit_boss

@export var lungeX = 300
@export var lungeY = 120

var direction = 0
var override_x = false

func _ready():
	bite_box.disabled = true
	bite_box_init_position = bite_box_parent.position
	hurt_box_init_position = hurt_box.position

func _input(_event):
	if Input.is_action_just_pressed("attack"):
		_animation_player.play("attack")
	pass

func bite():
	#print("Killing bites!")
	override_x = true
	bite_box.disabled = false
	velocity.y = -lungeY
	if animated_sprite.flip_h == false:
		velocity.x = lungeX
	else:
		velocity.x = lungeX * -1

func finish_bite():
	bite_box.disabled = true
	override_x = false
	pass

func _physics_process(_delta):
	##I could totally write a function to handle reversing the positions, should have done it before but eh too late now with 27 hours left in the jam
	if direction == 1:
		bite_box_parent.position = bite_box_init_position
		hurt_box.position = hurt_box_init_position
	elif direction == -1:
		hurt_box.position = Vector2(
			hurt_box_init_position.x * direction,
			hurt_box.position.y
		)
		bite_box_parent.position = Vector2(
			bite_box_init_position.x * direction,
			bite_box_parent.position.y
		)
	pass

func _on_animation_player_animation_finished(anim_name):
	pass # Replace with function body.


func _on_bite_box_body_entered(body):
	print(body)
	if body is Boss:
		print('hit boss')
		hit_boss.emit()
		pass
	pass # Replace with function body.
