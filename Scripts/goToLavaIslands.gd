extends TextureButton

func _pressed():
	get_tree().change_scene_to_file("res://Scenes/lava_islands_overview.tscn")
