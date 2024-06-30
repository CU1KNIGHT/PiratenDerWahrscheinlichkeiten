extends TextureButton


func _pressed():
	Global.global_current_island="gegenereignis-island"
	get_tree().change_scene_to_file("res://Scenes/grundlage/gegenereignisse.tscn")
