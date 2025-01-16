extends AudioStreamPlayer
#
#const levelMusic = [
	##preload("res://assets/sounds/Wormo Main Theme Rough.mp3"),
	##preload("res://a")
#]

func play_sfx(new_stream: AudioStream, volume = 0.0):
	var fx_player = AudioStreamPlayer.new()
	fx_player.stream = new_stream
	fx_player.name = "FX_Player"
	fx_player.volume_db = volume
	add_child(fx_player)
	fx_player.play()
	await fx_player.finished
	fx_player.queue_free()

func play_music_level(levelMusic):
	_play_music(levelMusic, 0)

func _play_music(music: AudioStream, volume = 0.0):
	if stream == music:
		return
	stream = music
	volume_db = volume
	play()
	music.loop = true
	print(music.loop)
	pass
