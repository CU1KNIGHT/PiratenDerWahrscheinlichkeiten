extends Node2D


func _on_button_1_button_down():
	get_tree().change_scene_to_file("res://Scenes/basic_islands_overview.tscn")
	


func _on_button_2_button_down():
	get_tree().change_scene_to_file("res://Scenes/ice_islands_overview.tscn")
	

func _on_button_3_button_down():
	get_tree().change_scene_to_file("res://Scenes/lava_islands_overview.tscn")
	


func _on_button_4_button_down():
	get_tree().quit()
	
