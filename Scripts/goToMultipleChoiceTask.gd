extends Node2D

@onready var pause_menu = $PauseMenu
var paused = false

var richt_text_bubble

func _read():
	richt_text_bubble=$explanation_text
func _pressed():
	richt_text_bubble.visible = !richt_text_bubble.visible


func _ready():
	# Get the reference to the object to hide (RichTextLabel node)
	richt_text_bubble=$explanation_text
	$DoneButton.connect("pressed",Callable(self, "_on_DoneButton_pressed"))
	$Pause.connect("pressed",Callable(self, "_on_pause_pressed"))
	$BackToIslands.connect("pressed",Callable(self, "_on_back_to_islands_pressed"))


func _on_DoneButton_pressed():
	get_tree().change_scene_to_file("res://Scenes/grundlage/TasksMulti-choice.tscn")
	



func _on_pause_pressed():
	if paused:
		pause_menu.hide()
		Engine.time_scale = 1
	else:
		pause_menu.show()
		Engine.time_scale = 0
		
	paused = !paused 


func _on_back_to_islands_pressed():
	get_tree().change_scene_to_file("res://scenes/basic_islands_overview.tscn")
