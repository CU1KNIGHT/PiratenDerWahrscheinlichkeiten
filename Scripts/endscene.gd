extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_1_button_down():
	get_tree().change_scene_to_file("res://Scenes/basic_islands_overview.tscn")
	pass # Replace with function body.


func _on_button_2_button_down():
	get_tree().change_scene_to_file("res://Scenes/ice_islands_overview.tscn")
	pass # Replace with function body.


func _on_button_3_button_down():
	get_tree().change_scene_to_file("res://Scenes/lava_islands_overview.tscn")
	pass # Replace with function body.


func _on_button_4_button_down():
	get_tree().quit()
	pass # Replace with function body.
