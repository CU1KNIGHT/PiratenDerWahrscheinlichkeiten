extends Control

@onready var options_menu = $Menu
var shown = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_resume_pressed():
	get_tree().paused = false
	hide()




func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
	AudioPlayer.stop()
	AudioPlayer._play_music_menu()



func _on_settings_pressed():
	if shown:
		options_menu.hide()
		Engine.time_scale = 1
	else:
		options_menu.show()
		Engine.time_scale = 0
		
	shown = !shown
