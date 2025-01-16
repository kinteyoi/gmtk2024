extends CharacterBody2D

signal burnt
signal countered

var witnessed = false
var randomSpeed = randi_range(10, 20)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("fire")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if witnessed == true:
		self.global_position.x += 25
	else:
		self.global_position.x += -randomSpeed
	#move_and_slide()


func _on_area_2d_body_entered(body):
	print(body)
	##if player, deal damage
	##if swing, send to home
	pass # Replace with function body.


func _on_area_2d_area_entered(area):
	witnessed = true
	print("WITNESS ME")
	pass # Replace with function body.
