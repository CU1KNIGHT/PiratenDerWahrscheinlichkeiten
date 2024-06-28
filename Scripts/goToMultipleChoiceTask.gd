extends Node2D

var richt_text_bubble

func _read():
	richt_text_bubble=$explanation_text
func _pressed():
	richt_text_bubble.visible = !richt_text_bubble.visible


func _ready():
	# Get the reference to the object to hide (RichTextLabel node)
	richt_text_bubble=$explanation_text
	$DoneButton.connect("pressed",Callable(self, "_on_DoneButton_pressed"))


func _on_DoneButton_pressed():
	get_tree().change_scene_to_file("res://Scenes/grundlage/TasksMulti-choice.tscn")
	

