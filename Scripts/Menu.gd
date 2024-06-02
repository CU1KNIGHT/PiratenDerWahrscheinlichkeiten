extends Control

func _ready():
	AudioPlayer._play_music_menu()

func _on_spielen_pressed():
	AudioPlayer.stop()
	get_tree().change_scene_to_file("res://intro.tscn")


func _on_optionen_pressed():
	get_tree().change_scene_to_file("res://options_menu.tscn")


func _on_schließen_pressed():
	get_tree().quit()
