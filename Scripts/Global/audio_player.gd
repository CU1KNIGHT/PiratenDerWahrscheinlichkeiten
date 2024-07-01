extends AudioStreamPlayer

const menu_music = preload("res://resources/audio/bgm/menu.mp3")
const gameplay1_music = preload("res://resources/audio/bgm/gameplay1.mp3")


func _ready():
	bus = "Music"

	
func _play_music(music: AudioStream, wantToLoop = true, volume = 0.0):
	if stream == music:
		return
	
	stream = music
	volume_db = volume
	music.loop = wantToLoop
	
	play()

func _play_music_menu():
	_play_music(menu_music)
	
func _play_music_gameplay1():
	_play_music(gameplay1_music)
	
func stop_music():
	stop()
