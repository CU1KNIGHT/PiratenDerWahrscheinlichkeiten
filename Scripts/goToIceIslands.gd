extends TextureButton

func _pressed():
	get_tree().change_scene_to_file("res://scenes/basic_islands_overview.tscn")
