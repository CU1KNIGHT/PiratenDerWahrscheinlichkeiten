extends Node2D
var richt_text_bubble
func _read():
	richt_text_bubble=$explanation_text
func _pressed():
	richt_text_bubble.visible = !richt_text_bubble.visible


func _ready():
	# Get the reference to the object to hide (RichTextLabel node)
	richt_text_bubble=$explanation_text
	$OkButton.connect("pressed",Callable(self, "_on_OkButton_pressed"))
	$DoneButton.connect("pressed",Callable(self, "_on_DoneButton_pressed"))
# Method to hide the object
func hide_object():
	richt_text_bubble.visible = false
	$OkButton.visible=false

# Method to show the object (if you want to toggle visibility)
func show_object():
	richt_text_bubble.visible = true

# Method to toggle the object's visibility when the button is pressed
func _on_OkButton_pressed():
	if richt_text_bubble.visible:
		hide_object()
	else:
		show_object()
func _on_DoneButton_pressed():
	get_tree().change_scene_to_file("res://scenes/basic_islands_overview.tscn")
	

