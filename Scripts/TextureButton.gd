extends TextureButton

func _pressed():
	get_tree().change_scene_to_file("res://Scenes/game_map.tscn")
