extends CharacterBody2D

var jumped = false
@export var gravity := 500
@export var lunge_strength := 400
signal touched_player(monster)

func lunge():
	$AnimationPlayer.play("fela")
	jumped = true
	$Flea.visible = true
	$Fleaspawn.visible = false
	velocity.y = -lunge_strength
	print("flea: RAH!")

func _physics_process(delta):
	if jumped == true:
		#print("flea is succumbing to gravity")
		velocity.y += gravity * delta
		pass
	move_and_slide()

func _on_area_2d_body_entered(body):
	if body.has_method("shake"):
		$AnimationPlayer2.play("spawn")
		print("a flea smells the worm")

#func _on_area_2d_body_entered(body):



func _on_hurt_box_body_entered(body):
	if body is Player:
		touched_player.emit("flea")
