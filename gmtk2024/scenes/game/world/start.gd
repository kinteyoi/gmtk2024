extends StaticBody2D

@onready var spawnPos = $SpawnPosition

func get_spawn_pos():
	return spawnPos.global_position
