extends AudioStreamPlayer

const menu_music = preload("res://resources/audio/bgm/menu.mp3")

func _ready():
	bus = "Music"
	
func _play_music(music: AudioStream, volume = 0.0):
	if stream == music:
		return
	
	stream = music
	volume_db = volume
	
	play()

func _play_music_menu():
	_play_music(menu_music)
	
func stop_music():
	stop()
